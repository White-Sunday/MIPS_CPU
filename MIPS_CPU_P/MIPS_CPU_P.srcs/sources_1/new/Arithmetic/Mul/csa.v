`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: coprocessor1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: carry save adder
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module csa (a,b,ci,s,c);	// carry save adders
	input a,b,ci;		// input a,b,carry_in
	output s,c;		// output sum,carry_out
	assign c = a&b | b&ci | ci&a;
	assign s = (a^b)^ci;
endmodule






