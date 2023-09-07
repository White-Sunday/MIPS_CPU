`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_wb
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


module pipe_wb #(parameter WIDTH=32, REGBITS=5)(
    input [WIDTH-1:0] wb_mrd,
    input [WIDTH-1:0] wb_alu,
    input [REGBITS-1:0] wb_rn,
    input wb_wreg,
    input wb_m2reg,
    output [WIDTH-1:0] wb_rwd);

    mux2x32 wdi_sel(wb_alu,wb_mrd,wb_m2reg,wb_rwd);
endmodule
