`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/21 20:24:16
// Design Name: 
// Module Name: rom
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


module rom(
    input [9:0] addr,
    output [31:0] read_data);
    reg [31:0] bit_array[1023:0];

    initial begin
        $readmemh("D:/Data/Code/Verilog/MIPS_CPU/MIPS_CPU/MIPS_CPU.srcs/sources_1/new/memfile.dat",bit_array);
    end

    assign read_data = bit_array[addr];

endmodule
