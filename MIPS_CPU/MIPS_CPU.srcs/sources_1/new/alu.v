`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/01 17:06:30
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 运算器
// 暂时没有对add做溢出判断处理
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu#(parameter WIDTH=32)(
    input [WIDTH-1:0] a,b,
    input [3:0] alu_cont,
    output reg [WIDTH-1:0] result);

    wire [WIDTH-1:0] b2;
    wire [WIDTH-1:0] add_res;
    wire [WIDTH-1:0] sub_res;
    wire [WIDTH-1:0] and_res;
    wire [WIDTH-1:0] or_res;
    wire [WIDTH-1:0] xor_res;
    wire [WIDTH-1:0] slt;
    wire [WIDTH-1:0] sltu;
    wire [WIDTH-1:0] sgt;

    assign b2 = ~b+1;
    assign add_res = a+b;
    assign sub_res = a+b2;
    assign and_res = a&b;
    assign or_res = a|b;
    assign xor_res = a^b;
    assign slt = sub_res[WIDTH-1]?32'h1:32'h0;  //有符号比较 set less than
    assign sltu = (a<b)?32'h1:32'h0;        //无符号比较
    assign sgt = sub_res[WIDTH-1]?32'h0:32'h1;  //有符号比较 set greater than

    always @(*)begin
        case (alu_cont[3:0])
            4'b0000: result = add_res;                  //add
            4'b0001: result = sub_res;                  //sub
            4'b0010: result = and_res;                  //and
            4'b0011: result = or_res;                   //or
            4'b0100: result = xor_res;                  //xor
            4'b0101: result = (a==b);                   //(a==b)?1:0
            4'b0110: result = slt;                      //(a<b)?1:0
            4'b0111: result = sltu;                     //(a<b)?1:0 (u)
            4'b1000: result = sgt;                      //(a>b)?1:0
            4'b1001: result = (b<<a);                   //sll
            4'b1010: result = (b>>a);                   //srl
        endcase
    end
endmodule
