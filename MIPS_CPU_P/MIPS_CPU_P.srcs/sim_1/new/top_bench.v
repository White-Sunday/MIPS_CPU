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

    reg [31:0] a;
    reg [31:0] b;
    reg ci;
    wire [31:0] s;

    test test_soc(a,b,ci,s);
    
    // initial 
    // begin
    //     clk<=0;
    //     reset <=1;
    //     #22;
    //     reset <=0;
    // end

    initial 
    begin
        clk<=0;
        reset <=1;
        a <= -4;
        b <= 1;
        ci <= 1;
    end

    always #5 clk=~clk;
endmodule
