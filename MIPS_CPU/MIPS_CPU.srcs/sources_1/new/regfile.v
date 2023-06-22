`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/01 16:54:51
// Design Name: 
// Module Name: regfile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 寄存器组
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile #(parameter WIDTH=32,REGBITS=5)(
    input clk,
    input reg_write,
    input [REGBITS-1:0] reg_read_addr1, reg_read_addr2, reg_write_addr,
    input [WIDTH-1:0] reg_write_data,
    output [WIDTH-1:0] reg_read_data1, reg_read_data2);
    
    reg [WIDTH-1:0] REG[(1<<REGBITS)-1:0];  //32个寄存器 32 x 2^5

    initial begin
        REG[0] <= 32'b0;
        REG[29] <= 32'h1fe8;    //$sp堆栈指针寄存器赋初值
    end

    always @(posedge clk)begin
        if(reg_write) REG[reg_write_addr] <= reg_write_data;
    end

    assign reg_read_data1 = reg_read_addr1?REG[reg_read_addr1]:0;    //这里做了一个逻辑上的处理，即使REG[0]物理上被改写了，返回的仍然是0
    assign reg_read_data2 = reg_read_addr2?REG[reg_read_addr2]:0;
    
endmodule