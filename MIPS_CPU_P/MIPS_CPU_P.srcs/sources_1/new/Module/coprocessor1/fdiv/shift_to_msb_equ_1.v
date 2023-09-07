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
// Dependencies: shift left util msb = 1; MSB（MostSignificant Bit)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_to_msb_equ_1 (a,b,sa);   // shift left util msb = 1; MSB（MostSignificant Bit）
    input [23:0] a;                     // shift a = xxx...xxx
    output [23:0] b;                     // to b = 1xx...xx
    output [4:0] sa;                    // how many bits shifted
    wire [23:0] a5,a4,a3,a2,a1,a0;
    wire sa4,sa3,sa2,sa1,sa0;
    assign sa = {sa4,sa3,sa2,sa1,sa0};
    assign a5 = a;
    assign sa4 = ~|a5[23:8];            // 16-bit 0
    assign a4 = sa4? {a5[7:0],16'b0} : a5;
    assign sa3 = ~|a4[23:16];           // 8-bit 0
    assign a3 = sa3? {a4[15:0],8'b0} : a4;
    assign sa2 = ~|a3[23:20];           // 4-bit 0
    assign a2 = sa2? {a3[19:0],4'b0} : a3;
    assign sa1 = ~|a2[23:22];           // 2-bit 0
    assign a1 = sa1? {a2[21:0],2'b0} : a2;
    assign sa0 = ~a1[23];               // 1-bit 0
    assign a0 = sa0? {a1[22:0],1'b0} : a1;
    assign b = a0;
endmodule