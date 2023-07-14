`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: dff
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 1 D flip-flops 1位D处理器
// 
// Dependencies: 复位信号低电平有效
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dff(d,clk,clrn,q);
    input d;
    input clk;
    input clrn;
    output reg q;

    always @ (negedge clrn or posedge clk) begin
        if (!clrn) begin
            q <= 0;         // 重置信号有效(低电平有效)q置为0
        end else begin
            q <= d;
        end
    end  
endmodule