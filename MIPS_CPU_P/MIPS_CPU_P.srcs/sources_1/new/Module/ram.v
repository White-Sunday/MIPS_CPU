`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: ram
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


module ram(
    input clk,
    input [9:0] addr,
    input [31:0] data_in,
    input we,
    output [31:0] data_out);

    reg [31:0] bit_array[1023:0];

    always @(posedge clk) begin
        if (we) begin
            bit_array[addr] <= data_in;
        end
    end
    assign data_out = bit_array[addr];
endmodule
