`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: data_mem
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


module data_mem #(parameter WIDTH=32, ADDR=32)(
    input clk,
    input [ADDR-1:0] addr,
    input [WIDTH-1:0] data_in,
    input we,
    output [WIDTH-1:0] data_out);

    ram data_ram(clk,addr[11:2],data_in,we,data_out);
endmodule