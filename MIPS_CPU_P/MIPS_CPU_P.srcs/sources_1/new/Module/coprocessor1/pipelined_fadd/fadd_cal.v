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
// Dependencies: fadder cal
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fadd_cal (op_sub,large_frac24,small_frac27,cal_frac);
	input op_sub;
	input [23:0] large_frac24;
	input [26:0] small_frac27;
	output [27:0] cal_frac;

	wire [27:0] aligned_large_frac = {1'b0, large_frac24, 3'b000};
	wire [27:0] aligned_small_frac = {1'b0, small_frac27};

	assign cal_frac = op_sub? 
		aligned_large_frac - aligned_small_frac :
		aligned_large_frac + aligned_small_frac;
endmodule
