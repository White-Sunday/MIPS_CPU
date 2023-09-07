`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: stall_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 管理iu,cp0,cp1产生的stall信号,并反馈一个整合后的stall信号
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stall_control (
    input st,
    input stl_lw,           // lw
    input stl_fp,           // 浮点指令数据冲突 
    input stl_ds,           // fdiv fsqrt
    input stl_lwc1,
    input stl_swc1,
    output stl_others,
    output stl);

    assign stl_others = stl_lw | stl_fp | stl_lwc1 | stl_swc1 | st;
    assign stl = stl_ds | stl_others;
    
endmodule