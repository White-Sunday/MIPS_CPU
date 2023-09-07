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
// Dependencies: fadder piplined reg cal_norm
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_cal_norm (c_rm,c_is_nan,c_is_inf,c_inf_nan_frac,c_sign,c_exp,
	c_frac,clk,clrn,e,n_rm,n_is_nan,n_is_inf,n_inf_nan_frac,n_sign,n_exp,n_frac);
	input [1:0] c_rm;
	input c_is_nan,c_is_inf,c_sign;
	input [22:0] c_inf_nan_frac;
	input [7:0] c_exp;
	input [27:0] c_frac;
	input clk;
	input clrn;
	input e;
	output reg [1:0] n_rm;
	output reg n_is_nan, n_is_inf, n_sign;
	output reg [22:0] n_inf_nan_frac;
	output reg [7:0] n_exp;
	output reg [27:0] n_frac;

	always @ (posedge clk or negedge clrn) begin
		if (!clrn) begin
			n_rm <= 0;
			n_is_nan <= 0;
			n_is_inf <= 0;
			n_inf_nan_frac <= 0;
			n_sign <= 0;
			n_exp <= 0;
			n_frac <= 0;
		end else if (e) begin
			n_rm <= c_rm;
			n_is_nan <= c_is_nan;
			n_is_inf <= c_is_inf;
			n_inf_nan_frac <= c_inf_nan_frac;
			n_sign <= c_sign;
			n_exp <= c_exp;
			n_frac <= c_frac;
		end
	end	
endmodule
