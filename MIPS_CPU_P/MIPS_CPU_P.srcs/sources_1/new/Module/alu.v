`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// aluc[3:0]
// X000 ADD
// X100 SUB
// X001 AND
// X101 OR
// X010 XOR
// X110 LUI
// 0011 SLL
// 0111 SRL
// 1111 SRA
// alu的设计思路
// 将9种计算分为四组: 1.ADD,SUB 2.AND,OR 3.XOR,LUI 4.SLL,SRL,SRA
// 由aluc[1:0]来决定结果是哪一组
// aluc[2]来进行1,2,3组的组内区分，
// aluc[3:2]来进行第4组的组内区分
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu #(parameter WIDTH=32)(
    input [WIDTH-1:0] a,        // alu操作数a
    input [WIDTH-1:0] b,        // alu操作数b
    input [3:0] aluc,           // alu操作控制信息
    output [WIDTH-1:0] r,       // alu运算结果
    output z);                  // 结果是否为0

    wire [WIDTH-1:0] add_r,sub_r,as_r;  // add_sub_r
    wire [WIDTH-1:0] and_r,or_r,ao_r;   // and_or_r
    wire [WIDTH-1:0] xor_r,lui_r,xl_r;  // xor_lui_r
    wire [WIDTH-1:0] sh_r;
    
    assign add_r = a + b;
    assign sub_r = a - b;
    mux2x32 as_sel(add_r,sub_r,aluc[2],as_r);
    assign and_r = a & b;
    assign or_r = a | b;
    mux2x32 ao_sel(and_r,or_r,aluc[2],ao_r);
    assign xor_r = a ^ b;
    assign lui_r = {b[15:0],16'h0};
    mux2x32 xl_sel(xor_r,lui_r,aluc[2],xl_r);
    shift#(WIDTH) shifter(b,a[4:0],aluc[2],aluc[3],sh_r);
    
    mux4x32 r_sel(add_sub_r,and_or_r,xor_lui_r,sh_r,aluc[1:0],r);
    assign z = ~|r;
endmodule