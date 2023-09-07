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
// Dependencies: fadder pipelined
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pipelined_fadder (clk,clrn,a,b,sub,rm,e,s);
	input clk, clrn;	// clock and reset
	input [31:0] a, b;
	input sub;		// 0-add; 1-sub
	input [1:0] rm;		// round mode
	input e;		// enable
	output [31:0] s;
	
	wire [26:0] a_small_frac;
	wire [23:0] a_large_frac;
	wire [22:0] a_inf_nan_frac;
	wire [7:0] a_exp;
	wire a_is_nan, a_is_inf;
	wire a_sign;
	wire a_op_sub;
	
	// alignment stage
	fadd_align alignment (a,b,sub,a_is_nan,a_is_inf,a_inf_nan_frac,
		a_sign,a_exp,a_op_sub,a_large_frac,a_small_frac);
	
	wire [26:0] c_small_frac;
	wire [23:0] c_large_frac;
	wire [22:0] c_inf_nan_frac;
	wire [7:0] c_exp;
	wire [1:0] c_rm;
	wire c_is_nan, c_is_inf;
	wire c_sign;
	wire c_op_sub;

	// pipelined registers
	reg_align_cal reg_ac (rm,a_is_nan,a_is_inf,a_inf_nan_frac,a_sign,a_exp,
		a_op_sub,a_large_frac,a_small_frac,clk,clrn,e,
		c_rm,c_is_nan,c_is_inf,c_inf_nan_frac,c_sign,
		c_exp,c_op_sub,c_large_frac,c_small_frac);
	wire [27:0] c_frac;

	// calculation stage
	fadd_cal calculation (c_op_sub, c_large_frac, c_small_frac, c_frac);
	wire [27:0] n_frac;
	wire [22:0] n_inf_nan_frac;
	wire [7:0] n_exp;
	wire [1:0] n_rm;
	wire n_is_nan, n_is_inf;
	wire n_sign;

	// pipelined registers
	reg_cal_norm reg_cn (c_rm,c_is_nan,c_is_inf,c_inf_nan_frac,c_sign,c_exp,
		c_frac,clk,clrn,e,n_rm,n_is_nan,n_is_inf,
		n_inf_nan_frac,n_sign,n_exp,n_frac);

	// normalization stage
	fadd_norm normalization (n_rm,n_is_nan,n_is_inf,n_inf_nan_frac,n_sign,n_exp,n_frac,s);

endmodule
