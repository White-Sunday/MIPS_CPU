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
// Dependencies: root newton
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module root_newton24 (d,fsqrt,ena,clk,clrn,q,busy,count,reg_x,stall);
	input [23:0] d;		// radicand
	input fsqrt;		// ID stage: fsqrt=i_fsqrt
	input clk;
	input clrn;
	input ena;
	output [31:0] q;	// root: .1xxx...x
	output busy;		// cannot receive new fsqrt
	output stall;		// stall to save result
	output [4:0] count;	// for sim test only
	output [25:0] reg_x;	// for sim test only

	reg [31:0] q;		// 31-bit: .1xxx...x
	reg [23:0] reg_d;	// 24-bit: .xxxx...x (MSB 01 or 1x)
	reg [25:0] reg_x;	// 26-bit: xx.xxx...x
	reg [4:0] count;	// 3 iterations * 7 cycles
	reg busy;
	wire [7:0] x0 = rom(d[23:19]);
	wire [51:0] x_2,x2d,x52;	// xxxx.xxx...x
	always @ (posedge clk or negedge clrn) begin
		if (!clrn) begin
			count <= 0;
			busy <= 0;
			reg_x <= 0;
		end else begin
			if (fsqrt & (count==0)) begin
				count <= 5'b1;		// set count
				busy <= 1'b1;		// set busy
			end else begin
				if (count==5'h1) begin			// 3 iterations
					reg_x <= {2'b1,x0,16'b0};	// 01.x...x0...0
					reg_d <= d;			//   .xxxxxx...x (MSB 01 or 1x)
				end
				if (count!=0) count <= count+5'b1;	// count ++
				if (count==5'h15) busy <= 0;		// ready for next
				if (count==5'h16) count <= 0;		// reset count
				if ((count==5'h08) ||			// 2 3 4 5 6 7 8 save result of 1st iteration
				    (count==5'h0f) ||			// 9 10 11 12 13 14 15 save result of 2nd iteration
				    (count==5'h16)) 			// 16 17 18 19 20 21 22 no need to save here actually
					reg_x <= x52[50:25];		// xi*(3-xi*xi*d)/2	// xxx.xxx...x->xx.xxx...x (div 2)
			end
		end
	end
	assign stall = fsqrt & (count==0) | busy;
	// wallace_26x26_product (a,b,z)
	wallace_26x26_product x2 (reg_x,reg_x,x_2);	// x_2=xi*xi	// 00xx.xxx...x (1.0<x_2<4.0)
	wallace_24x28_product xd (reg_d,x_2[51:24],x2d);// x2d=xi*xi*d	// 00xx.xxx...x (x2d<4.0)
	wire [25:0] b26 = 26'h3000000 - x2d[49:24];	// b26=3-xi*xi*d (11.000...0-xi*xi*d)	// xx.xxx...x
	wallace_26x26_product xip1 (reg_x,b26,x52);	// xip1(x_i_plus_1)=xi(3-xi*xi*d)	// 0xxx.xxx...x
	reg [25:0] reg_de_x;				// pipeline register "xn" in between id and e1
	reg [23:0] reg_de_d;				// pipeline register "d" in between id and e1
	wire [49:0] m_s;				// sum of wallace result
	wire [49:8] m_c;				// carry of wallace result
	// wallace_24x26 (a,b,x,y,z)
	wallace_24x26 wt(reg_de_d,reg_de_x,m_s[49:8],m_c,m_s[7:0]);	// d*xn
	reg [49:0] a_s;
	reg [49:8] a_c;
	wire [49:0] d_x = a_s + {a_c,8'b0};
	wire [31:0] e2p = {d_x[47:17],|d_x[16:0]};
	// pipeline registers
	always @ (negedge clrn or posedge clk) begin
		if (!clrn) begin
			reg_de_x <= 0;	reg_de_d <= 0;	// id-e1
			a_s <= 0;	a_c <= 0;			// e1-e2
			q <= 0;							// e2-e3
		end else if (ena) begin
			reg_de_x <= x52[50:25];	reg_de_d <= reg_d;	// id-e1
			a_s <= m_s;		a_c <= m_c;					// e1-e2
			q <= e2p;									// e2-e3
		end
	end
	// a rom table: 1/d^{1/2}
	function [7:0] rom;
		input [4:0] d;
		case (d)
			5'h08: rom = 8'hff;
			5'h09: rom = 8'he1;
			5'h0a: rom = 8'hc7;
			5'h0b: rom = 8'hb1;
			5'h0c: rom = 8'h9e;
			5'h0d: rom = 8'h9e;
			5'h0e: rom = 8'h7f;
			5'h0f: rom = 8'h72;
			5'h10: rom = 8'h66;
			5'h11: rom = 8'h5b;
			5'h12: rom = 8'h51;
			5'h13: rom = 8'h48;
			5'h14: rom = 8'h3f;
			5'h15: rom = 8'h37;
			5'h16: rom = 8'h30;
			5'h17: rom = 8'h29;
			5'h18: rom = 8'h23;
			5'h19: rom = 8'h1d;
			5'h1a: rom = 8'h17;
			5'h1b: rom = 8'h12;
			5'h1c: rom = 8'h0d;
			5'h1d: rom = 8'h08;
			5'h1e: rom = 8'h04;
			5'h1f: rom = 8'h00;
			default: rom = 8'hff;
		endcase
	endfunction
endmodule
