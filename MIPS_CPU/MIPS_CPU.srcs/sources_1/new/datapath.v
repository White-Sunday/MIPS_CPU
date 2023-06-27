`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/01 ADDR-1:38:05
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 数据通路
// 内含运算器alu、寄存器组rf及各种触发器、多路选择器、连线
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath #(parameter WIDTH=32, ADDR=16, REGBITS=5, CONST_ZERO = 32'b0, CONST_FOUR = 32'b100)(
    input clk, reset,
    input [WIDTH-1:0] mem_data_in,
    input ir_write,
    input [1:0] pc_src_sel,  
    input pc_en,
    input [1:0] alu_srca_sel,
    input [2:0] alu_srcb_sel,
    input [3:0] alu_cont,
    input addr_sel,
    input [1:0] mem_write_data_sel,
    input [1:0] reg_write_data_sel,
    input [1:0] reg_write_addr_sel,
    input reg_write,
    output branch_en,        //pc是否分支跳转
    output [31:0] instr,
    output [ADDR-1:0] addr,
    output [WIDTH-1:0] mem_write_data);

    wire [REGBITS-1:0] reg_read_addr1, reg_read_addr2, reg_write_addr;      //寄存器组的两个读入地址和一个写入地址
    wire [WIDTH-1:0] reg_read_data1, reg_read_data2;                        //寄存器组的两个数据读出（32位）
    wire [WIDTH-1:0] reg_write_data;                                        //寄存器组的写入数据
    wire [WIDTH-1:0] a, b;                                                  //reg_read_data1与reg_read_data2给a，b（D触发器）
    wire [WIDTH-1:0] pc, next_pc;                                           //pc与下一个pc值
    wire [WIDTH-1:0] src1, src2;                                            //alu的两个计算数来源
    wire [WIDTH-1:0] alu_result, alu_out;   //alu的即时计算结果和计算结果寄存器存储（alu_out的值为当前节拍上升沿到来时的上一个节拍的alu_result的值）
    wire [WIDTH-1:0] constx4;               //targetPC值，最高4位保持PC原值不变，接下来26位为指令target字段，最低4位为00
    wire [WIDTH-1:0] offsetx4;              //指令offset字段算术左移2位，再符号拓展至32位（补码左移，末位补0）
    wire [WIDTH-1:0] shamt;                 //rt中的32位数逻辑左右移shamt位，这里将shamt字段转为32位的数
    wire [WIDTH-1:0] offset_s;              //指令中的offset字段或imme字段符号拓展至32位
    wire [WIDTH-1:0] offset_u;               //指令中的imme字段无符号拓展至32位
    wire [WIDTH-1:0] offset_h;               //指令中的imme字段左移16位，低位补0   
    wire [WIDTH-1:0] mem_data;              //主存读出数据，mem_data_in作为输入的D触发器输出
    wire [WIDTH-1:0] mem_read_byte_u;       //lbu写回数据：{24'b0,mem_data[7:0]}
    wire [WIDTH-1:0] mem_read_halfword_u;   //lhu写回数据：{16'b0,mem_data[15:0]}
    wire [WIDTH-1:0] mem_write_byte;        //sb写入内存数据：{mem_data_in[31:8],b[7:0]}
    wire [WIDTH-1:0] mem_write_halfword;    //sh写入内存数据：{mem_data_in[31:16],b[15:0]}

    //pc寄存器，clk上升沿值改变
    flopenr #(WIDTH) pc_reg(
    .clk(clk),
    .en(pc_en),
    .reset(reset),
    .d(next_pc),
    .q(pc));
    //ir使能D触发器，clk上升沿值改变
    flopen #(WIDTH) instr_reg(clk,ir_write,mem_data_in,instr);

    //存储器地址addr二路选择器————作用可以理解为MAR
    mux2 #(ADDR) addr_mux(pc[ADDR-1:0],alu_out[ADDR-1:0],addr_sel,addr);
    //主存数据D触发器，clk上升沿值改变————作用可以理解为MDR
    flop #(WIDTH) mem_data_reg(clk,mem_data_in,mem_data);

    //寄存器组两个输入端
    assign reg_read_addr1 = instr[REGBITS+20:21];
    assign reg_read_addr2 = instr[REGBITS+15:16];
    //寄存器组地址reg_write_addr四路选择器
    mux4 #(REGBITS) reg_write_addr_mux(instr[REGBITS+15:16],instr[REGBITS+10:11],5'b11111,5'b11111,reg_write_addr_sel,reg_write_addr);
    assign mem_read_byte_u = {24'b0,mem_data[7:0]};
    assign mem_read_halfword_u = {16'b0,mem_data[15:0]};
    //寄存器组写入数据reg_write_data四路选择器
    mux4 #(WIDTH) reg_write_data_mux(alu_out,mem_data,mem_read_byte_u,mem_read_halfword_u,reg_write_data_sel,reg_write_data);
    //寄存器组rf
    regfile #(WIDTH,REGBITS) rf(
        .clk(clk), 
        .reg_write(reg_write),
        .reg_read_addr1(reg_read_addr1), 
        .reg_read_addr2(reg_read_addr2),
        .reg_write_addr(reg_write_addr),
        .reg_write_data(reg_write_data),
        .reg_read_data1(reg_read_data1), 
        .reg_read_data2(reg_read_data2));

    //关于a和writedata（b）的两个D触发器
    flop #(WIDTH) a_reg(clk,reg_read_data1,a);
    flop #(WIDTH) b_reg(clk,reg_read_data2,b);
    
    //指令里的数值类型字段处理
    assign constx4 = {pc[31:28],instr[25:0],2'b00};  //j、jal target
    assign offsetx4 = instr[ADDR-1]?{14'b11111111111111,instr[ADDR-1:0],2'b00}:{14'b0,instr[ADDR-1:0],2'b00};  //beq、bne、bgtz offset
    assign shamt = {27'b0,instr[10:6]};  //srl、sll shamt
    assign offset_s = instr[ADDR-1]?{16'b1111111111111111,instr[ADDR-1:0]}:{16'b0,instr[ADDR-1:0]};  //lw、sw offset、i型指令imme（符号拓展）
    assign offset_u = {16'b0,instr[ADDR-1:0]};  //i型指令imme（无符号拓展）
    assign offset_h = {instr[ADDR-1:0],16'b0};  //i型指令imme（左移16位，低位补0）
    assign mem_write_byte = {mem_data_in[31:8],b[7:0]};
    assign mem_write_halfword = {mem_data_in[31:16],b[15:0]};

    //存储器写数据
    mux4 #(WIDTH) mem_write_data_mux(b,mem_write_byte,mem_write_halfword,CONST_ZERO,mem_write_data_sel,mem_write_data);

    //alu计算数来源1四路选择器
    mux4 #(WIDTH) src1_mux(pc,a,shamt,CONST_ZERO,alu_srca_sel,src1);
    //alu计算数来源2八路选择器
    mux8#(WIDTH) src2_mux(b,CONST_FOUR,offset_s,offsetx4,offset_u,offset_h,CONST_ZERO,CONST_ZERO,alu_srcb_sel,src2);
    //alu
    alu #(WIDTH) alu_unit(src1,src2,alu_cont,alu_result);
    //alu输出结果D触发器，clk上升沿值改变
    flop #(WIDTH) alu_res_reg(clk,alu_result,alu_out);
    //alu计算结果是否为0
    assign branch_en = (alu_result==1);

    //输出pc下一个值的四路选择器
    mux4 #(WIDTH) pc_mux(alu_result,alu_out,constx4,CONST_ZERO,pc_src_sel,next_pc);
endmodule

