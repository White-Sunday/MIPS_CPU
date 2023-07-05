`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_if
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


module pipe_if #(parameter WIDTH=32, ADDR=32)(
    input [1:0] pc_src,             // next_pc选择信号
    input [WIDTH-1:0] pc,
    input [WIDTH-1:0] b_pc,         // branch pc
    input [WIDTH-1:0] r_pc,         // reg pc
    input [WIDTH-1:0] j_pc,         // jump pc
    output [WIDTH-1:0] next_pc,     // next pc
    output [WIDTH-1:0] pc4,         // pc+4
    output [WIDTH-1:0] instr);

    mux4x32 next_pc_cntr(pc,b_pc,r_pc,j_pc,pc_src,next_pc); // 选择next pc
    cla32 pc_plus4(pc,32'h4,1'b0,pc4);                      // pc+4
    inst_mem#(WIDTH, ADDR) i_mem(pc,instr);                 // 从内存中取指令
endmodule