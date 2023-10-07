`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_fd_reg
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


module pipe_fd_reg #(parameter WIDTH=32)(
    input clk,
    input clrn,
    input ir_wen,
    input [WIDTH-1:0] pc4,
    input [WIDTH-1:0] instr,
    output [WIDTH-1:0] id_pc4,
    output [WIDTH-1:0] id_instr);

    dffe32 fd_pc4(pc4,clk,clrn,ir_wen,id_pc4);
    dffe32 fd_instr(instr,clk,clrn,ir_wen,id_instr);
endmodule