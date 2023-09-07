`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_mem
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


module pipe_mem #(parameter WIDTH=32, ADDR=32)(
    input clk,
    input [WIDTH-1:0] addr,
    input [WIDTH-1:0] data_in,      // data in (to mem)
    input we,                       // 存储器写信号
    output [WIDTH-1:0] data_out);   // data out (from mem)

    data_mem#(WIDTH,ADDR) d_mem(clk,addr,data_in,we,data_out);
endmodule