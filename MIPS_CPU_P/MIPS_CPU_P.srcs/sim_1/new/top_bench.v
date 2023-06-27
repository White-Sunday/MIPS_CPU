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

    top soc(
    .clk(clk),
    .reset(reset));
    
    initial 
    begin
        clk<=0;
        reset <=1;
        #22;
        reset <=0;
    end

    always #5 clk=~clk;
endmodule
