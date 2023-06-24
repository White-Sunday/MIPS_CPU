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
    input clk,
    input reset,
    input [5:0] op,         //操作码
    input [5:0] func,       //函数码
    input zero,             //alu计算结果是否为0信号
    output reg mem_write,
    output reg reg_write,
    output reg reg_write_sel,
    output reg addr_sel,
    output reg ir_write,
    output pc_en,
    output reg [1:0] reg_write_addr_sel, //寄存器地址多路选择控制信号
    output reg [1:0] pc_src_sel,
    output reg [1:0] alu_srca_sel,
    output reg [2:0] alu_srcb_sel,
    output reg [2:0] alu_op);
    
    reg [7:0] state, next_state;  //节拍状态、下一状态
    reg pc_write, pc_write_cond;

    //状态码
    //取指、译指阶段状态（高位000）
    parameter FETCH = 8'b000_00000;    //取指令
    parameter DECODE = 8'b000_00001;   //解析指令（ir_write <= 1且clk上升沿到来指令写入ir）
    //访存型I型指令指令状态（高位001）
    parameter MEMADR = 8'b001_00000;   //计算aluresult = rs + offset16，下一周期到来aluout = aluresult
    parameter LWMEM = 8'b001_00001;
    parameter LWWR = 8'b001_00010;
    parameter SWWR = 8'b001_00011;     //计算aluresult = rs + offset16，addr_sel <= 1
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
    parameter ITYPEWR = 8'b010_11111;  //结果写入寄存器，寄存器地址默认reg_write_addr_sel <= 2'b00指向rt提供地址，下一个clk上升沿到来成功写入
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
    parameter RTYPEWR = 8'b100_11111;  //结果写入寄存器，寄存器地址经由reg_write_addr_sel <= 2'b01指向rd提供地址，下一个clk上升沿到来成功写入
    //J型指令状态（高位101）
    parameter JEX = 8'b101_00000;
    parameter JALEX = 8'b101_00001;
    parameter JALWR = 8'b101_00010;
    parameter PCWAIT = 8'b101_11111;   //专门用来等待pc完成变化的节拍
    
    //操作码
    parameter ADDI = 6'b001000; 
    parameter ANDI = 6'b001100;
    parameter BEQ = 6'b000100;
    parameter BGTZ = 6'b000111;
    parameter BNE = 6'b000101;
    parameter J = 6'b000010;
    parameter JAL = 6'b000011;
    parameter LUI = 6'b001111;
    parameter LW = 6'b100011;
    parameter ORI = 6'b001101;
    parameter SW = 6'b101011;
    parameter RTYPE = 6'b000000;
    parameter SLL = 6'b000000;
    parameter SRL = 6'b000010;
    parameter SLT = 6'b101010;
    parameter JR = 6'b001000;

    //节拍状态初始化与状态转变
    always @(posedge clk)
        if(reset) state <= FETCH;
        else state <= next_state;

    //下一节拍状态
    always @(*) begin
        case(state)
            //取指周期状态
            FETCH: next_state = DECODE;
            //译指周期状态
            DECODE: case(op)
                        LW: next_state = MEMADR;
                        SW: next_state = MEMADR;
                        RTYPE: 
                            case(func)
                                SLL: next_state = SLLEX;
                                SRL: next_state = SRLEX;
                                JR:  next_state = JREX;
                                default: next_state = RTYPEEX;  //这里的default是指add等典型的R型指令
                            endcase
                        BEQ:  next_state = BEQEX;
                        BGTZ: next_state = BGTZEX;
                        ADDI: next_state = ADDIEX;
                        ANDI: next_state = ANDIEX;
                        LUI:  next_state = LUIEX;
                        ORI:  next_state = ORIEX;
                        BNE:  next_state = BNEEX;
                        J:    next_state = JEX;
                        JAL:  next_state = JALEX;
                        default: next_state = FETCH;    //default应该永远不会发生
                    endcase
            //访存指令状态
            MEMADR: case(op)
                        LW:   next_state = LWMEM;
                        SW:   next_state = SWWR;
                        default: next_state = FETCH;    //default应该永远不会发生
                    endcase
            //lw    
            LWMEM:  next_state = LWWR;      //访存-数据准备好，MDR在下一拍改变
            LWWR:   next_state = FETCH;     //写回-真正写进入还得在下一拍
            //sw
            SWWR:   next_state = FETCH;     //写回-mem_write_data在上一拍已经准备好了，这一排改变信号，真正写入在下一拍
            //r
            RTYPEEX: next_state = RTYPEWR;
            RTYPEWR: next_state = FETCH;
            //srl
            SRLEX:  next_state = RTYPEWR;
            //sll
            SLLEX:  next_state = RTYPEWR;
            //jr
            JREX:   next_state = RTYPEWR;
            //beq
            BEQEX:  next_state = PCWAIT;    //还需要一拍来改变PC
            //bgtz
            BGTZEX: next_state = PCWAIT;    //还需要一拍来改变PC
            //bne
            BNEEX:  next_state = PCWAIT;    //还需要一拍来改变PC
            //i型
            //andi
            ANDIEX: next_state = ITYPEWR;
            //addi
            ADDIEX: next_state = ITYPEWR;
            //ori
            ORIEX:  next_state = ITYPEWR;
            //lui
            LUIEX:  next_state = ITYPEWR;
            //i
            ITYPEWR: next_state = FETCH;
            //j
            JEX:    next_state = PCWAIT;
            //jal
            JALEX: next_state = JALWR;
            JALWR: next_state = PCWAIT;
            //pcwait
            PCWAIT: next_state = FETCH;
            //default应该永远不会发生
            default: next_state = FETCH;
        endcase
    end

    always @(*) begin
        //每次执行该模块内容前，事先将下列信号置为0
        ir_write = 0;
        pc_write = 0;
        pc_write_cond = 0;
        reg_write = 0;
        reg_write_addr_sel = 2'b00;
        mem_write = 0;
        alu_srca_sel = 2'b00;
        alu_srcb_sel = 3'b000;
        alu_op = 3'b000;
        pc_src_sel = 2'b00;
        addr_sel = 0;
        reg_write_sel = 0;
        case(state)
            FETCH: begin
                ir_write = 1;
                alu_srcb_sel = 3'b001;
                pc_write = 1;
            end
            DECODE: begin
                alu_op = 3'b000;
                alu_srcb_sel = 3'b011;
            end
            MEMADR: begin
                alu_srca_sel = 2'b01;
                alu_srcb_sel = 3'b010;
            end
            LWMEM: begin
                addr_sel = 1;
            end
            LWWR: begin
                reg_write = 1;
                reg_write_sel = 1;
            end
            SWWR: begin
                mem_write = 1;
                addr_sel = 1;
            end
            RTYPEEX: begin
                alu_op = 3'b111;
                alu_srca_sel = 2'b01;
            end
            RTYPEWR: begin
                reg_write_addr_sel = 2'b01;
                reg_write = 1;
            end
            SRLEX: begin
                alu_op = 3'b111;
                alu_srca_sel = 2'b10;
            end
            SLLEX: begin
                alu_op = 3'b111;
                alu_srca_sel = 2'b10;
            end
            JREX: begin
                pc_write = 1;
                alu_op = 3'b111;
                alu_srca_sel = 2'b01;
                alu_srcb_sel = 3'b110;
            end
            BEQEX: begin
                alu_srca_sel = 2'b01;
                alu_op = 3'b010;
                pc_write_cond = 1;
                pc_src_sel = 2'b01;
            end
            BGTZEX: begin
                alu_srca_sel = 2'b01;
                alu_op = 3'b100;
                pc_write_cond = 1;
                pc_src_sel = 2'b01;
            end
            BNEEX: begin
                alu_srca_sel = 2'b01;
                alu_op = 3'b011;
                pc_write_cond = 1;
                pc_src_sel = 2'b01;
            end
            ANDIEX: begin
                alu_op = 3'b001;
                alu_srca_sel = 2'b01;
                alu_srcb_sel = 3'b100;
            end
            ADDIEX: begin
                alu_op = 3'b000;
                //a+offset16
                alu_srca_sel = 2'b01;
                alu_srcb_sel = 3'b010;
            end
            ORIEX: begin
                alu_op = 3'b110;
                alu_srca_sel = 2'b01;
                alu_srcb_sel = 3'b100;
            end
            LUIEX: begin
                alu_op = 3'b101;
                alu_srca_sel = 2'b01;
                alu_srcb_sel = 3'b101;
            end
            ITYPEWR: begin
                reg_write = 1;
            end
            JEX: begin
                pc_write = 1;
                pc_src_sel = 2'b10;
            end
            JALEX: begin
                alu_srcb_sel = 3'b001;
                alu_op = 3'b000;
            end
            JALWR: begin
                reg_write_addr_sel = 2'b10;
                reg_write = 1;
                // alu_op <= 3'b000;
                // alu_srcb_sel <= 3'b011;
                pc_write = 1;
                pc_src_sel = 2'b10;
            end
            PCWAIT: begin

            end
        endcase
    end
    assign pc_en = pc_write | (pc_write_cond&zero);            
endmodule
