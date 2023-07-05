`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: dffe32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32 D flip-flops enable 32位带使能的D处理器
// 
// Dependencies: 复位信号低电平有效
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dffe32(d,clk,clrn,e,q);
    input [31:0] d;
    input clk;
    input clrn;
    input e;
    output reg [31:0] q;

    always @ (negedge clrn or posedge clk) begin
        if (!clrn) begin
            q <= 0;         // 重置信号有效(低电平有效)q置为0
        end else if (e) begin
            q <= d;
        end
    end  
endmodule