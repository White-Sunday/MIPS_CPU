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
// Dependencies: fadder align
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fadd_align (a,b,sub,s_is_nan,s_is_inf,inf_nan_frac,sign,temp_exp,
	op_sub,large_frac24,small_frac27);
	input [31:0] a;
	input [31:0] b;
	input sub;
	output s_is_nan;
	output s_is_inf;
	output [22:0] inf_nan_frac;
	output sign;
	output [7:0] temp_exp;
	output op_sub;
	output [23:0] large_frac24;
	output [26:0] small_frac27;
	
	wire exchange = (b[30:0]>a[30:0]);
	wire [31:0] fp_large = exchange? b : a;
	wire [31:0] fp_small = exchange? a : b;

	wire fp_large_hidden_bit = |fp_large[30:23];
	wire fp_small_hidden_bit = |fp_small[30:23];
	
	assign large_frac24 = {fp_large_hidden_bit, fp_large[22:0]};
	wire [23:0] small_frac24 = {fp_small_hidden_bit, fp_small[22:0]};

	assign temp_exp = fp_large[30:23];
	assign sign = exchange? sub^b[31] : a[31];
	assign op_sub = sub^fp_large[31]^fp_small[31];		// op for absolute calcutlation

	wire fp_large_expo_is_ff = &fp_large[30:23];		// exp == 0xff
	wire fp_small_expo_is_ff = &fp_small[30:23];
	wire fp_large_frac_is_00 = ~|fp_large[22:0];		// frac == 0x00
	wire fp_small_frac_is_00 = ~|fp_small[22:0];
	
	wire fp_large_is_inf = fp_large_expo_is_ff & fp_large_frac_is_00;
	wire fp_small_is_inf = fp_small_expo_is_ff & fp_small_frac_is_00;
	wire fp_large_is_nan = fp_large_expo_is_ff & ~fp_large_frac_is_00;
	wire fp_small_is_nan = fp_small_expo_is_ff & ~fp_small_frac_is_00;

	assign s_is_inf = fp_large_is_inf | fp_small_is_inf;
	assign s_is_nan = fp_large_is_nan | fp_small_is_nan | 
		((sub^fp_small[31]^fp_large[31])&fp_large_is_inf & fp_small_is_inf);

	wire [22:0] nan_frac = (a[21:0]>b[21:0])?{1'b1,a[21:0]}:{1'b1,b[21:0]};
	assign inf_nan_frac = s_is_nan? nan_frac : 23'b0;

	wire [7:0] exp_diff = fp_large[30:23] - fp_small[30:23];
	wire small_den_only = (fp_large[30:23]!=0) & (fp_small[30:23]==0);
	wire [7:0]  shift_amount = small_den_only? exp_diff - 8'h1 : exp_diff;
	wire [49:0] small_frac50 = (shift_amount>=26)?
		{26'h0, small_frac24} :
		{small_frac24,26'h0} >> shift_amount;
	assign small_frac27 = {small_frac50[49:24], |small_frac50[23:0]};		
endmodule
