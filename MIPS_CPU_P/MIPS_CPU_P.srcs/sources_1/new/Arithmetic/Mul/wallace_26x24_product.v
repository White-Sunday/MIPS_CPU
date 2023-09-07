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
// Dependencies: 26*24 wallacetree product
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wallace_26x24_product (a,b,z);	// 26*24 wallacetree product
	input [25:0] a;
	input [23:0] b;
	output [49:0] z;
	wire [49:8] x;
	wire [49:8] y;
	wire [49:8] z_high;
	wire [7:0] z_low;
	wallace_26x24 wt_partial (a,b,x,y,z_low);
	assign z_high = x+y;
	assign z = {z_high, z_low};	// product
endmodule
