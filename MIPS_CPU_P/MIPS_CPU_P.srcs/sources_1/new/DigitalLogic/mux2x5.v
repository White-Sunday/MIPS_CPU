`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: mux2x5
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32位的2对1多路选择器
// 
// Dependencies: 复位信号低电平有效
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux2x5(a0,a1,s,y);
    input [4:0] a0;
    input [4:0] a1;
    input s;
    output [4:0] y;

    assign y = s ? a1 : a0;
endmodule