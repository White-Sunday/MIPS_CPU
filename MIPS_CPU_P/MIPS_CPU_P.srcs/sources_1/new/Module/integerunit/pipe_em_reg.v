`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_em_reg
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


module pipe_em_reg #(parameter WIDTH=32, REGBITS=5)(
    input clk,
    input clrn,
    input [WIDTH-1:0] exe_alu,
    input [WIDTH-1:0] exe_b,
    input [REGBITS-1:0] exe_rn,
    input exe_wreg,
    input exe_m2reg,
    input exe_wmem,
    output reg [WIDTH-1:0] mem_alu,
    output reg [WIDTH-1:0] mem_b,
    output reg [REGBITS-1:0] mem_rn,
    output reg mem_wreg,
    output reg mem_m2reg,
    output reg mem_wmem);

    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin
            mem_alu <= 0;
            mem_b <= 0;
            mem_rn <= 0;
            mem_wreg <= 0;
            mem_m2reg <= 0;
            mem_wmem <= 0;
        end else begin
            mem_alu <= exe_alu;
            mem_b <= exe_b;
            mem_rn <= exe_rn;
            mem_wreg <= exe_wreg;
            mem_m2reg <= exe_m2reg;
            mem_wmem <= exe_wmem;
        end
    end
endmodule