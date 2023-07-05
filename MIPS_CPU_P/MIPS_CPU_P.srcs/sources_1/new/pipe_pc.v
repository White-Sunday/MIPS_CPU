`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 就是一个简单的32位使能D触发器
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pipe_pc #(parameter WIDTH=32)(
    input clk,
    input clrn,
    input pc_wen,
    input [WIDTH-1:0] next_pc,
    output [WIDTH-1:0] pc);

    dffe32 prog_cntr(next_pc,clk,clrn,pc_wen,pc);
endmodule