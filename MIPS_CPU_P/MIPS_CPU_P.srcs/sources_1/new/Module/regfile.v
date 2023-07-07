`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: regfile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 这里用英文注释舒服点
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile #(parameter WIDTH=32, REGBITS=5)(
    input clk,
    input clrn,
    input [WIDTH-1:0] d,        // data of write port
    input [REGBITS-1:0] ra,     // reg # of read port A
    input [REGBITS-1:0] rb,     // reg # of read port B
    input [REGBITS-1:0] wn,     // reg # of write port
    input we,                   // write enable
    output [WIDTH-1:0] qa,      // read port A
    output [WIDTH-1:0] qb);     // read port B

    reg [31:0] register [1:31]; // default reg[0]==0
    assign qa = (ra==0)? 0 : register[ra];
    assign qb = (rb==0)? 0 : register[rb];

    integer i;
    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin                // reset
            for (i=1;i<32;i=i+1)
                register[i] <= 0;
            register[29] <= 32'h1fe8;    //$sp堆栈指针寄存器赋初值
        end else begin
            if ((wn!=0) && we) begin    // not reg[0] and enabled
                register[wn] <= d;
            end
        end
    end
endmodule
