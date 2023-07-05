`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_mw_reg
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


module pipe_mw_reg #(parameter WIDTH=32, REGBITS=5)(
    input clk,
    input clrn,
    input [WIDTH-1:0] mem_mrd,
    input [WIDTH-1:0] mem_alu,
    input [REGBITS-1:0] mem_rn,
    input mem_wreg,
    input mem_m2reg,
    output reg [WIDTH-1:0] wb_mrd,
    output reg [WIDTH-1:0] wb_alu,
    output reg [REGBITS-1:0] wb_rn,
    output reg wb_wreg,
    output reg wb_m2reg);

    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin
            wb_mrd <= 0;
            wb_alu <= 0;
            wb_rn <= 0;
            wb_wreg <= 0;
            wb_m2reg <= 0;
        end else begin
            wb_mrd <= mem_mrd;
            wb_alu <= mem_alu;
            wb_rn <= mem_rn;
            wb_wreg <= mem_wreg;
            wb_m2reg <= mem_m2reg;
        end        
    end
endmodule