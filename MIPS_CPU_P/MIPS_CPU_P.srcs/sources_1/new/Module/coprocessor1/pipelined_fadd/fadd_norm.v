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
// Dependencies: fadder norm
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fadd_norm (rm,is_nan,is_inf,inf_nan_frac,sign,temp_exp,cal_frac,s);
	input [1:0] rm;
	input is_nan,is_inf;
	input sign;
	input [22:0] inf_nan_frac;
	input [7:0] temp_exp;
	input [27:0] cal_frac;
	output [31:0] s;

	wire [26:0] f4,f3,f2,f1,f0;
	wire zero4,zero3,zero2,zero1,zero0;
	wire [4:0] zeros = {zero4,zero3,zero2,zero1,zero0};
	assign zero4 = ~|cal_frac[26:11];			// 16-bit
	assign f4 = zero4? {cal_frac[10:0],16'b0} : cal_frac[26:0];
	assign zero3 = ~|f4[26:19];				// 8-bit
	assign f3 = zero3? {f4[18:0], 8'b0} : f4;
	assign zero2 = ~|f3[26:23];				// 4-bit
	assign f2 = zero2? {f3[22:0], 4'b0} : f3;
	assign zero1 = ~|f2[26:25];				// 2-bit
	assign f1 = zero1? {f2[24:0], 2'b0} : f2;
	assign zero0 = ~f1[26];					// 1-bit
	assign f0 = zero0? {f1[25:0], 1'b0} : f1;

	reg [26:0] frac0;
	reg [7:0] exp0;
	always @ * begin
		if (cal_frac[27]) begin				// 1x.xxxxxxxxxxxxxxxxxxxxxxx xxx
			frac0 = cal_frac[27:1];			//  1.xxxxxxxxxxxxxxxxxxxxxxx xxx
			exp0 = temp_exp + 8'h1;
		end else begin
			if ((temp_exp>{3'b0,zeros}) && (f0[26])) begin	// a normalized number
				frac0 = f0;
				exp0 = temp_exp - {3'b0,zeros};
			end else begin					// a denormalized number or zero
				exp0 = 0;
				if (temp_exp != 0) begin		// fp_large is normalized
					frac0 = cal_frac[26:0] << (temp_exp - 8'h1);
				end else begin				// fp_large is denormalized
					frac0 = cal_frac[26:0];
				end
			end
		end
	end
	wire frac_plus_1 = 						// rm:11 grs:xxx toward zero frac_plus_1=0
		~rm[1] & ~rm[0] & frac0[2] & (frac0[1] | frac0[0])|	// rm:00 grs:1xx(>100)
		~rm[1] & ~rm[0] & frac0[2] & ~frac0[1] & ~frac0[0] & frac0[3]|	// rm:00 grs:100 toward even
		~rm[1] & rm[0] & (frac0[2] | frac0[1] | frac0[0]) & sign|	// rm:01 grs:xxx(>000) toward minus inf
		rm[1] & ~rm[0] & (frac0[2] | frac0[1] | frac0[0]) & ~sign;	// rm:10 grs:xxx(>000) toward plus inf
	wire [24:0] frac_round = {1'b0,frac0[26:3]} + {24'b0,frac_plus_1};
	wire [7:0] exponent = frac_round[24]? exp0+8'h1 : exp0;
	wire overflow = &exp0 | &exponent;
	assign s = final_result(overflow, rm, sign, is_nan, is_inf, exponent, frac_round[22:0], inf_nan_frac);
	function [31:0] final_result;
		input overflow;
		input [1:0] rm;
		input sign, is_nan, is_inf;
		input [7:0] exponent;
		input [22:0] fraction, inf_nan_frac;
		/* verilator lint_off CASEX */
		/* verilator lint_off CASEOVERLAP */
		casex ({overflow, rm, sign, is_nan, is_inf})
			6'b1_00_x_0_x : final_result = {sign,8'hff,23'h000000};	// inf
			6'b1_01_0_0_x : final_result = {sign,8'hfe,23'h7fffff};	// max
			6'b1_01_1_0_x : final_result = {sign,8'hff,23'h000000};	// inf
			6'b1_10_0_0_x : final_result = {sign,8'hff,23'h000000};	// inf
			6'b1_10_1_0_x : final_result = {sign,8'hfe,23'h7fffff};	// max
			6'b1_11_x_0_x : final_result = {sign,8'hfe,23'h7fffff};	// max
			6'b0_xx_x_0_0 : final_result = {sign,exponent,fraction};	// nor
			6'bx_xx_x_1_x : final_result = {1'b1,8'hff,inf_nan_frac};	// nan
			6'bx_xx_x_0_1 : final_result = {sign,8'hff,inf_nan_frac};	// inf
			default       : final_result = {sign,8'h00,23'h000000}; // 0
		endcase
	endfunction
endmodule
