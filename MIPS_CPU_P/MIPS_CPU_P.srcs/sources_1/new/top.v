`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/30 09:19:59
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: CPU设计的top模块，并非标准的总线结构
// 注：指导书中没有使用到mem_read信号，这里也没有，但这里也懒得删去。 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top#(parameter WIDTH=32, ADDR=16, REGBITS=5)(
    input clk,              //时钟
    input reset);           //系统复位

    //信号
    wire mem_write;         //存储器写信号

    //地址
    wire [ADDR-1:0] addr;           //地址线

    //数据
    wire [WIDTH-1:0] mem_write_data;    //存储器写入数据
    wire [WIDTH-1:0] mem_read_data;     //存储器读出数据
    
    //CPU
    mips #(WIDTH,ADDR,REGBITS) cpu(
        .clk(clk), 
        .reset(reset), 
        .mem_read(mem_read), 
        .mem_write(mem_write),
        .addr(addr),
        .mem_read_data(mem_read_data), 
        .mem_write_data(mem_write_data));

    //主存，外设数据直接写入
    memory #(WIDTH,ADDR) mem(
        .clk(clk),
        .mem_write(mem_write),
        .addr(addr),
        .mem_write_data(mem_write_data),
        .mem_read_data(mem_read_data));

endmodule

