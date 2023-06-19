`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/30 11:19:01
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 控制器
// 
// R型指令： op(6bits) Rs(5bits) Rt(5bits) Rd(5bits) shamt(5bits) funct(6bits)
// I型指令： op(6bits) Rs(5bits) 立即数（16bits）
// J型指令： op(6bits) 立即数（26bits)
//
// 注：
// 1.关于时序，clk永远是一个节拍周期内所有信号中最先变化的，所以@(posedge clk)时处理的永远是上一个节拍的值
// 2.always@(*)语句的意思是always模块中的任何一个输入信号或电平发生变化时，模块中语句将被执行，controller的always@(*)模块不包含clk，
// 所以always@(posedge clk)永远在always@(*)之前执行，也就是说DECODE状态下，虽然指令分析和指令写入在同一节拍内发生，但是指令写入是先发生的。
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller(
    input clk,reset,
    input [5:0] op,         //操作码
    input [5:0] func,       //函数码
    input zero,             //alu计算结果是否为0信号
    output reg memread,memwrite,memtoreg,iord,
    output pcen,
    output reg regwrite,
    output reg [1:0] regdst, //寄存器地址多路选择控制信号
    output reg [1:0] pcsource,
    output reg [2:0] alusrcb,
    output reg [1:0] alusrca,
    output reg [2:0] aluop,
    output reg irwrite);
    
    reg [7:0] state, nextstate;  //节拍状态、下一状态
    reg pcwrite, pcwritecond;

    //状态码
    //取指、译指阶段状态（高位000）
    parameter FETCH1 = 8'b000_00001;   //取指令（包括下一周期）
    parameter FETCH2 = 8'b000_00010;   //取指令、pc+1、irwrite <= 1
    parameter DECODE = 8'b000_00011;   //解析指令（irwrite <= 1且clk上升沿到来指令写入ir）
    //访存型I型指令指令状态（高位001）
    parameter MEMADR = 8'b001_00000;   //计算aluresult = rs + offset16，下一周期到来aluout = aluresult
    parameter LWRD1 = 8'b001_00001;    //iord <= 1，这一信号和aluout要持续三个节拍，因为存储器要两个clk上升沿才能完成数据的读取
    parameter LWRD2 = 8'b001_00010;
    parameter LWRD3 = 8'b001_00011;
    parameter LWWR = 8'b001_00100;     //写入寄存器，由于时钟的原因，下一个clk上升沿到来时才会成功写入
    parameter SWWR1 = 8'b001_00101;    //计算aluresult = rs + offset16，iord <= 1
    parameter SWWR2 = 8'b001_00110;
    parameter SWWR3 = 8'b001_00111;
    parameter SB = 8'b001_01000;
    parameter SH = 8'b001_01001;
    //运算型I型指令状态（高位010）
    parameter ADDIEX = 8'b010_00000;
    parameter ADDIUEX = 8'b010_00001;
    parameter ANDIEX = 8'b010_00010;
    parameter LBUEX = 8'b010_00011;
    parameter LHUEX = 8'b010_00100;
    parameter LUIEX = 8'b010_00100;
    parameter ORIEX = 8'b010_00101;
    parameter SLTIEX = 8'b010_00110;
    parameter SLTIUEX = 8'b010_00111;
    parameter XORIEX = 8'b010_01000;
    parameter ITYPEWR = 8'b010_11111;  //结果写入寄存器，寄存器地址默认regdst <= 2'b00指向rt提供地址，下一个clk上升沿到来成功写入
    //条件分支型I型指令指令状态（高位011）
    parameter BEQEX = 8'b011_00000;
    parameter BGTZEX = 8'b011_00001;
    parameter BLTZEX = 8'b011_00010;
    parameter BNEEX = 8'b011_00011;
    //R型指令状态（高位100）
    //典型R型指令（add，addu，and，sub）使用节拍：RTYPEEX + RTYPEWR
    //（高位100_0）
    parameter ADDEX = 8'b100_0_0000;
    parameter ADDUEX = 8'b100_0_0001;
    parameter ANDEX = 8'b100_0_0010;
    parameter NOREX = 8'b100_0_0010;
    parameter OREX = 8'b100_0_0011;
    parameter SLLVEX = 8'b100_0_0100;
    parameter SLTEX = 8'b100_0_0101;
    parameter SLTUEX = 8'b100_0_0110;
    parameter SRAVEX = 8'b100_0_0111;
    parameter SUBEX = 8'b100_0_1000;
    parameter SUBUEX = 8'b100_0_1001;
    parameter XOREX = 8'b100_0_1010;
    //非典型R型指令（sll，srl）使用节拍：XXEX + RTYPEWR
    //（高位100_1）
    parameter SLLEX = 8'b100_1_0010;
    parameter SRLEX = 8'b100_1_0011;
    parameter JREX = 8'b100_1_0100;
    parameter SRAEX = 8'b100_1_0101;
    parameter RTYPEEX = 8'b100_11110;
    parameter RTYPEWR = 8'b100_11111;  //结果写入寄存器，寄存器地址经由regdst <= 2'b01指向rd提供地址，下一个clk上升沿到来成功写入
    //J型指令状态（高位101）
    parameter JEX = 8'b101_00000;
    parameter JALEX1 = 8'b101_00001;
    parameter JALEX2 = 8'b101_00010;
    parameter JWAIT1 = 8'b101_11110;   //pc值改变后，需要等待三个节拍，也就是两个clk上升沿（包括FETCH1）完成指令的读取
    parameter JWAIT2 = 8'b101_11111;
    
    //操作码
    parameter ADDI = 8'b001000; 
    parameter ANDI = 8'b001100;
    parameter BEQ = 8'b000100;
    parameter BGTZ = 8'b000111;
    parameter BNE = 8'b000101;
    parameter J = 8'b000010;
    parameter JAL = 8'b000011;
    parameter LUI = 8'b001111;
    parameter LW = 8'b100011;
    parameter ORI = 8'b001101;
    parameter SW = 8'b101011;
    parameter RTYPE = 8'b000000;
    parameter SLL = 8'b000000;
    parameter SRL = 8'b000010;
    parameter SLT = 8'b101010;
    parameter JR = 8'b001000;

    //节拍状态初始化与状态转变
    always @(posedge clk)
        if(reset) state <= FETCH1;
        else state <= nextstate;

    //下一节拍状态
    always @(*) begin
        case(state)
            //取指周期状态
            FETCH1: nextstate = FETCH2;
            FETCH2: nextstate = DECODE;
            //译指周期状态
            DECODE: case(op)
                        LW: nextstate = MEMADR;
                        SW: nextstate = MEMADR;
                        RTYPE: 
                            case(func)
                                SLL: nextstate = SLLEX;
                                SRL: nextstate = SRLEX;
                                JR:  nextstate = JREX;
                                default: nextstate = RTYPEEX;
                                //这里的default是指add等典型的R型指令
                            endcase
                        BEQ:  nextstate = BEQEX;
                        BGTZ: nextstate = BGTZEX;
                        ADDI: nextstate = ADDIEX;
                        ANDI: nextstate = ANDIEX;
                        LUI:  nextstate = LUIEX;
                        ORI:  nextstate = ORIEX;
                        BNE:  nextstate = BNEEX;
                        J:    nextstate = JEX;
                        JAL:  nextstate = JALEX1;
                        default: nextstate = FETCH1;
                        //default应该永远不会发生
                    endcase
            //访存指令状态
            MEMADR: case(op)
                        LW:   nextstate = LWRD1;
                        SW:   nextstate = SWWR1;
                        default: nextstate = FETCH1;
                        //default应该永远不会发生
                    endcase
            //lw    
            LWRD1:  nextstate = LWRD2;
            LWRD2:  nextstate = LWRD3;
            LWRD3:  nextstate = LWWR;
            LWWR:   nextstate = FETCH1;
            //sw
            SWWR1:  nextstate = SWWR2;
            SWWR2:  nextstate = SWWR3;
            SWWR3:  nextstate = FETCH1;
            //r
            RTYPEEX: nextstate = RTYPEWR;
            RTYPEWR: nextstate = FETCH1;
            //srl
            SRLEX:  nextstate = RTYPEWR;
            //sll
            SLLEX:  nextstate = RTYPEWR;
            //jr
            JREX:   nextstate = RTYPEWR;
            //beq
            BEQEX:  nextstate = JWAIT1;  //地址改变后需要有足够的时间取指令
            //bgtz
            BGTZEX: nextstate = JWAIT1;  //地址改变后需要有足够的时间取指令
            //bne
            BNEEX:  nextstate = JWAIT1;  //地址改变后需要有足够的时间取指令
            //i型
            //andi
            ANDIEX: nextstate = ITYPEWR;
            //addi
            ADDIEX: nextstate = ITYPEWR;
            //ori
            ORIEX:  nextstate = ITYPEWR;
            //lui
            LUIEX:  nextstate = ITYPEWR;
            //i
            ITYPEWR: nextstate = FETCH1;
            //j
            JEX:    nextstate = JWAIT1;
            //jal
            JALEX1: nextstate = JALEX2;
            JALEX2: nextstate = JWAIT1;
            //jwait
            JWAIT1: nextstate = JWAIT2;
            JWAIT2: nextstate = FETCH1;

            default: nextstate = FETCH1;
            //default应该永远不会发生
        endcase
    end

    always @(*) begin
        //每次执行该模块内容前，事先将下列信号置为0
        irwrite = 0;
        pcwrite = 0;
        pcwritecond = 0;
        regwrite = 0;
        regdst = 2'b00;
        memread = 0;
        memwrite = 0;
        alusrca = 2'b00;
        alusrcb = 3'b000;
        aluop = 3'b000;
        pcsource = 2'b00;
        iord = 0;
        memtoreg = 0;
        case(state)
            FETCH1: begin
                memread = 1;  
            end
            FETCH2: begin
                irwrite = 1;
                alusrcb = 3'b001;
                pcwrite = 1;    
            end
            DECODE: begin
                aluop = 3'b000;
                alusrcb = 3'b011;
            end
            MEMADR: begin
                alusrca = 2'b01;
                alusrcb = 3'b010;
            end
            LWRD1: begin
                alusrca = 2'b01;
                alusrcb = 3'b010;
                memread = 1;
                iord = 1;
            end
            LWRD2: begin
                alusrca = 2'b01;
                alusrcb = 3'b010;
                memread = 1;
                iord = 1;
            end
            LWRD3: begin
                memread = 1;
                iord = 1;
            end
            LWWR: begin
                regwrite = 1;
                memtoreg = 1;
            end
            SWWR1: begin
                alusrca = 2'b01;
                alusrcb = 3'b010;
                memwrite = 1;
                iord = 1;
            end
            SWWR2: begin
                alusrca = 2'b01;
                alusrcb = 3'b010;
                memwrite = 1;
                iord = 1;
            end
            SWWR3: begin  
                memwrite = 1;
                iord = 1;
            end
            RTYPEEX: begin
                aluop = 3'b111;
                alusrca = 2'b01;
            end
            RTYPEWR: begin
                regdst = 2'b01;
                regwrite = 1;
            end
            SRLEX: begin
                aluop = 3'b111;
                alusrca = 2'b10;
            end
            SLLEX: begin
                aluop = 3'b111;
                alusrca = 2'b10;
            end
            JREX: begin
                pcwrite = 1;
                aluop = 3'b111;
                alusrca = 2'b01;
                alusrcb = 3'b110;
            end
            BEQEX: begin
                alusrca = 2'b01;
                aluop = 3'b010;
                pcwritecond = 1;
                pcsource = 2'b01;
            end
            BGTZEX: begin
                aluop = 3'b100;
                alusrca = 2'b01;
                pcwritecond = 1;
                pcsource = 2'b01;
            end
            BNEEX: begin
                alusrca = 2'b01;
                aluop = 3'b011;
                pcwritecond = 1;
                pcsource = 2'b01;
            end
            ANDIEX: begin
                aluop = 3'b001;
                alusrca = 2'b01;
                alusrcb = 3'b100;
            end
            ADDIEX: begin
                aluop = 3'b000;
                //a+offset16
                alusrca = 2'b01;
                alusrcb = 3'b010;
            end
            ORIEX: begin
                aluop = 3'b110;
                alusrca = 2'b01;
                alusrcb = 3'b100;
            end
            LUIEX: begin
                aluop = 3'b101;
                alusrca = 2'b01;
                alusrcb = 3'b101;
            end
            ITYPEWR: begin
                regwrite = 1;
            end
            JEX: begin
                pcwrite = 1;
                pcsource = 2'b10;
            end
            JALEX1: begin
                alusrcb = 3'b001;
                aluop = 3'b000;
            end
            JALEX2: begin
                regdst = 2'b10;
                regwrite = 1;
                // aluop <= 3'b000;
                // alusrcb <= 3'b011;
                pcwrite = 1;
                pcsource = 2'b10;
            end
            JWAIT1: begin
                memread = 1;
            end
            JWAIT2: begin
                memread = 1;
            end
        endcase
    end
    assign pcen = pcwrite | (pcwritecond&zero);            
endmodule
