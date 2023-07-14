`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_exe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pipe_exe #(parameter WIDTH=32, REGBITS=5)(
    input [WIDTH-1:0] exe_a,
    input [WIDTH-1:0] exe_b,
    input [WIDTH-1:0] exe_imm,
    input [WIDTH-1:0] exe_pc4,
    input [REGBITS-1:0] exe_rn0,
    input [3:0] exe_aluc,
    input exe_shift,
    input exe_alu_imm,
    input exe_jal,
    output [WIDTH-1:0] exe_alu,
    output [REGBITS-1:0] exe_rn,
    output ov);

    // 用于获得jal所需要的pc+8的独立加法器
    wire [WIDTH-1:0] pc8;
    cla32 pc_plus8(exe_pc4,32'h4,1'b0,pc8);         // pc+8 for jal

    // 获得exe_rn
    assign exe_rn = exe_jal? 5'b11111 : exe_rn0;    // jal指令规定的$31

    // 计算exe_alu0
    wire [WIDTH-1:0] alu_a;
    wire [WIDTH-1:0] alu_b;
    wire [WIDTH-1:0] exe_alu0;
    wire z;                                         // alu结果是否为0,这里没用
    wire [WIDTH-1:0] sa = {27'h0,exe_imm[10:6]};    // shift amount
    mux2x32 alu_a_sel(exe_a,sa,exe_shift,alu_a);
    mux2x32 alu_b_sel(exe_b,exe_imm,exe_alu_imm,alu_b);
    alu#(WIDTH) au(alu_a,alu_b,exe_aluc,exe_alu0,z,ov);

    // 获得exe_alu: 从exe_alu0和pc+8中选择一个作为exe_alu
    mux2x32 ealu_sel(exe_alu0,pc8,exe_jal,exe_alu);
endmodule