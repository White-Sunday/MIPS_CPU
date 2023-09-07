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
// Dependencies: 协处理器1-fpu
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fpu #(parameter WIDTH=32, REGBITS=5)(
    input clk,
    input clrn,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [REGBITS-1:0] fd,
    input [2:0] fc,
    input id_fw,                            // fw 运算型指令浮点寄存器写信号
    input ein1,
    input ein2,
    output [WIDTH-1:0] exe_d,
    output reg [WIDTH-1:0] wb_d,
    output reg [REGBITS-1:0] e1_fn,         // e1段到wb段的写目标浮点寄存器号
    output reg [REGBITS-1:0] e2_fn,
    output reg [REGBITS-1:0] e3_fn,
    output reg [REGBITS-1:0] wb_fn,
    output e1_fw,
    output reg e2_fw,
    output reg e3_fw,
    output reg wb_fw,
    output stl_ds);                         // 由fdiv和fsqrt导致的stall

    reg [WIDTH-1:0] exe_fa,exe_fb;
    reg sub;
    reg e1_fw0;
    wire [WIDTH-1:0] s_add,s_mul,s_div,s_sqrt;
    wire [4:0] count_div,count_sqrt;
    wire [25:0] reg_x_div,reg_x_sqrt;
    wire busy_div,stall_div;
    wire busy_sqrt,stall_sqrt;
    wire fdiv = fc[2] & ~fc[1];     // fc=3'b10x
    wire fsqrt = fc[2] & fc[1];     // fc=3'b11x
    reg [1:0] e1_fc,e2_fc,e3_fc;
    assign e1_fw = e1_fw0 & ein2;

    wire fpl_en = ein1 & ~stl_ds;   // e=~stall & ein1 表示fpu流水寄存器使能状态(float pipeline enable)

    // rm(round mode)默认为2'b00
    pipelined_fadder f_add(clk,clrn,a,b,sub,2'b0,fpl_en,s_add);
    pipelined_fmul f_mul(clk,clrn,a,b,2'b0,fpl_en,s_mul);
    fdiv_newton f_div(clk,clrn,a,b,2'b0,fdiv,fpl_en,s_div,busy_div,stall_div,count_div,reg_x_div);
    fsqrt_newton f_sqrt(clk,clrn,a,2'b0,fsqrt,fpl_en,s_sqrt,busy_sqrt,stall_sqrt,count_sqrt,reg_x_sqrt);

    assign stl_ds = stall_div | stall_sqrt;     // stall fdiv fsqrt 也是fpu的ID段stall
    mux4x32 fsel(s_add,s_mul,s_div,s_sqrt,e3_fc,exe_d);

    always @ (negedge clrn or posedge clk) begin
        if(!clrn) begin
            sub <= 0;       exe_fa <= 0;    exe_fb <= 0;
            e1_fc <= 0;     e1_fn <= 0;     e1_fw0 <= 0;
            e2_fc <= 0;     e2_fn <= 0;     e2_fw <= 0;
            e3_fc <= 0;     e3_fn <= 0;     e3_fw <= 0;
            wb_d <= 0;      wb_fw <= 0;     wb_fn <= 0;
        end else if(fpl_en) begin
            sub <= fc[0];       exe_fa <= a;        exe_fb <= b;
            e1_fc <= fc[2:1];   e1_fn <= fd;        e1_fw0 <= id_fw;
            e2_fc <= e1_fc;     e2_fn <= e1_fn;     e2_fw <= e1_fw;
            e3_fc <= e2_fc;     e3_fn <= e2_fn;     e3_fw <= e2_fw;
            wb_d <= exe_d;      wb_fn <= e3_fn;     wb_fw <= e3_fw;
        end
    end
endmodule