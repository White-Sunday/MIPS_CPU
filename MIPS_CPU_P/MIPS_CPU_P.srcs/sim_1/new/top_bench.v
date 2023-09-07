`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/01 17:12:05
// Design Name: 
// Module Name: top_bench
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


module top_bench();
    reg clk;
    reg reset;
    reg intr;
    wire inta;
    wire ein1 = 1'b1;
    wire ein2 = 1'b1;
    wire st = 1'b0;


    iu_fpu_ei cpu(clk,reset,ein1,ein2,st,intr,inta);

    // reg [31:0] a;
    // reg [31:0] b;
    // reg ci;
    // wire [31:0] s;
    // test test_soc(a,b,ci,s);

    
    initial 
    begin
        clk <= 0;
        reset <= 0;
        intr <= 0;
        #22;
        reset <= 1;
        #158
        // stall时发生中断
        intr <= 1;
        #10;
        intr <= 0;
    end

    // test for exc int
    // initial 
    // begin
    //     clk <= 0;
    //     reset <= 0;
    //     intr <= 0;
    //     #22;
    //     reset <= 1;
    //     #598
    //     // 一般情况中断
    //     // intr <= 1;
    //     #10;
    //     // intr <= 0;
    //     #50
    //     // BJ指令ID段发生中断
    //     intr <= 1;
    //     #10;
    //     intr <= 0;
    // end

    always #5 clk=~clk;
endmodule
