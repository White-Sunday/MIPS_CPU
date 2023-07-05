`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_de_reg
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


module pipe_de_reg #(parameter WIDTH=32, REGBITS=5)(
    input clk,
    input clrn,
    input [WIDTH-1:0] id_a,
    input [WIDTH-1:0] id_b,
    input [WIDTH-1:0] id_imm,
    input [REGBITS-1:0] id_rn,
    input [WIDTH-1:0] id_pc4,
    input [3:0] id_aluc,
    input id_wreg,
    input id_m2reg,
    input id_wmem,
    input id_shift,
    input id_alu_imm,
    input id_jal,
    output reg [WIDTH-1:0] exe_a,
    output reg [WIDTH-1:0] exe_b,
    output reg [WIDTH-1:0] exe_imm,
    output reg [WIDTH-1:0] exe_rn0,
    output reg [WIDTH-1:0] exe_pc4,
    output reg [3:0] exe_aluc,
    output reg exe_wreg,
    output reg exe_m2reg,
    output reg exe_wmem,
    output reg exe_shift,
    output reg exe_alu_imm,
    output reg exe_jal);
    
    // 搓个大点的dff(D触发器)
    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin
            exe_a <= 0;
            exe_b <= 0;
            exe_imm <= 0;
            exe_rn0 <= 0;
            exe_pc4 <= 0;
            exe_aluc <= 0;
            exe_wreg <= 0;
            exe_m2reg <= 0;
            exe_wmem <= 0;
            exe_shift <= 0;
            exe_alu_imm <= 0;
            exe_jal <= 0;
        end else begin
            exe_a <= id_a;
            exe_b <= id_b;
            exe_imm <= id_imm;
            exe_rn0 <= id_rn;
            exe_pc4 <= id_pc4;
            exe_aluc <= id_aluc;
            exe_wreg <= id_wreg;
            exe_m2reg <= id_m2reg;
            exe_wmem <= id_wmem;
            exe_shift <= id_shift;
            exe_alu_imm <= id_alu_imm;
            exe_jal <= id_jal;
        end
    end
endmodule