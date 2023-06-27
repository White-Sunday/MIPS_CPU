`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/30 10:43:01
// Design Name: 
// Module Name: mips
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: CPU（controller+alu_control+datapath）
// controller可以看做CU，ALU在datapath里
// 已实现部分mips指令集:
// lw
// sw
// lbu
// lhu
// sb
// sh
// addi
// addiu
// andi
// ori
// xori
// lui
// slti
// sltiu
// beq
// bne
// bgtz
// bltz
// add
// addu
// sub
// subu
// and
// or
// nor
// xor
// 
// j
// jal
// jr
// sll
// slt
// sub
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mips #(parameter WIDTH=32, ADDR=16, REGBITS=5)(
    input clk,
    input reset,
    output mem_read,                //主存读信号
    output mem_write,               //主存写信号
    output [ADDR-1:0] addr,
    input [WIDTH-1:0] mem_read_data,        //主存数据                
    output [WIDTH-1:0] mem_write_data);     //写入主存数据
    
    wire [31:0] instr;      //指令

    //CU控制信号
    wire branch_en;         //pc是否分支跳转
    wire addr_sel;          //存储器地址addr二路选择信号
    wire pc_en;             //pc触发器使能信号，next_pc->pc
    wire ir_write;          //ir写信号
    wire reg_write;         //寄存器写信号
    wire [1:0] reg_write_data_sel;     //寄存器组写入数据选择信号
    wire [1:0] reg_write_addr_sel;      //寄存器组地址reg_write_addr四路选择
    wire [1:0] mem_write_data_sel;      //存储器写入数据mem_write_data四路选择
    wire [1:0] pc_src_sel;
    wire [3:0] alu_op;
    wire [1:0] alu_srca_sel;
    wire [2:0] alu_srcb_sel;
    wire [3:0] alu_cont;    //alu_control输出运算模式（控制ALU进行加还是减）信号
    
    //控制器controller
    controller cu(
        .clk(clk),
        .reset(reset),
        .op(instr[31:26]),
        .func(instr[5:0]),
        .branch_en(branch_en),
        .ir_write(ir_write),
        .pc_src_sel(pc_src_sel),
        .pc_en(pc_en),
        .alu_srca_sel(alu_srca_sel),
        .alu_srcb_sel(alu_srcb_sel),
        .alu_op(alu_op),
        .addr_sel(addr_sel),
        .mem_write_data_sel(mem_write_data_sel),
        .mem_write(mem_write),
        .reg_write_data_sel(reg_write_data_sel),
        .reg_write_addr_sel(reg_write_addr_sel),
        .reg_write(reg_write));
    
    //运算器控制alu_control 根据alu_op和指令操作码，输出信号控制ALU进行何种运算
    alucontrol ac(alu_op, instr[5:0], alu_cont);
    
    //数据通路datapath
    datapath #(WIDTH,ADDR,REGBITS) dp(
        .clk(clk),
        .reset(reset),
        .mem_data_in(mem_read_data),
        .ir_write(ir_write),
        .pc_src_sel(pc_src_sel),
        .pc_en(pc_en),
        .alu_srca_sel(alu_srca_sel),
        .alu_srcb_sel(alu_srcb_sel),
        .alu_cont(alu_cont),
        .addr_sel(addr_sel),
        .mem_write_data_sel(mem_write_data_sel),
        .reg_write_data_sel(reg_write_data_sel),
        .reg_write_addr_sel(reg_write_addr_sel),
        .reg_write(reg_write),
        .branch_en(branch_en),
        .instr(instr),
        .addr(addr),
        .mem_write_data(mem_write_data));
endmodule 

