`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/21 20:24:16
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
    input en,           // access enable
    input write_en,     // write enable
    input [9:0] addr,
    input [31:0] write_data,
    output [31:0] read_data);
    reg [31:0] bit_array [1023:0];

    // bit array write
    always @(posedge clk) begin
        if (en) begin
            if (write_en) begin
                bit_array[addr][31:0] <= write_data[31:0];
            end
        end
    end

    // bit array read
    assign read_data = bit_array[addr];
endmodule
