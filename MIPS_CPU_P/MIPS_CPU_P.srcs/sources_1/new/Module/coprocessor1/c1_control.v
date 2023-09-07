`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: c1_control
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


module c1_control #(parameter WIDTH=32, REGBITS=5)(
    input [5:0] op,
    input [5:0] func,
    input [REGBITS-1:0] fs,
    input [REGBITS-1:0] ft,
    input pc_ir_wen,
    input stl_others,       // 除了stl_ds的stall之或
    input exe_m2fr,
    input mem_m2fr,
    input [REGBITS-1:0] exe_frn,
    input [REGBITS-1:0] mem_frn,
    input e1_fw,
    input e2_fw,
    input e3_fw,
    input [REGBITS-1:0] e1_fn,
    input [REGBITS-1:0] e2_fn,
    input [REGBITS-1:0] e3_fn,
    output [2:0] fc,
    output swfp,
    output fwd_f,
    output fwd_fe,
    output fwd_la,
    output fwd_lb,
    output fwd_fa,
    output fwd_fb,
    output id_fw,
    output id_m2fr,
    output stl_fp,          // stall 浮点运算型指令
    output stl_lwc1,        // stall lwc1
    output stl_swc1,        // stall swc1
    output f_compu);        // 表示当前位于ID段的指令是否是浮点运算型指令

    // 指令译码
    wire i_lwc1 = (op == 6'b110001);
    wire i_swc1 = (op == 6'b111001);
    wire f_type = (op == 6'b010001);                 // f型指令
    wire i_fadd = f_type & (func == 6'b000000);      //  这里的i_前缀指的是instruction
    wire i_fsub = f_type & (func == 6'b000001);
    wire i_fmul = f_type & (func == 6'b000010);
    wire i_fdiv = f_type & (func == 6'b000011);
    wire i_fsqrt = f_type & (func == 6'b000100);

    // fpu control code
    // 000:fadd; 001:fsub; 01x:fmul; 10x:fdiv; 11x:fsqrt
    wire [2:0] fop;
    assign fop[0] = i_fsub;
    assign fop[1] = i_fmul | i_fsqrt;
    assign fop[2] = i_fdiv | i_fsqrt;
    // fc是fdiv,fsqrt的产生信号来源,既是fpu运算结果的选择信号,也是fdiv和fsqrt指令进入ID段迭代的启动按钮
    assign fc = fop & {3{~stl_others}}; // stl_ds以外的stall发生时,意味着fpu还在等待操作数,fdiv和fsqrt指令不能进入ID段迭代

    // 运算型浮点指令
    wire i_fs = i_fadd | i_fsub | i_fmul | i_fdiv | i_fsqrt;
    wire i_ft = i_fadd | i_fsub | i_fmul | i_fdiv;
    assign stl_fp = (e1_fw&(i_fs&(e1_fn==fs)|i_ft&(e1_fn==ft))) |
        (e2_fw&(i_fs&(e2_fn==fs)|i_ft&(e2_fn==ft)));    // stall 浮点运算型指令
    assign fwd_fa = e3_fw & (e3_fn==fs);
    assign fwd_fb = e3_fw & (e3_fn==ft);
    assign id_fw = i_fs & pc_ir_wen;                // fwreg
    assign f_compu = i_fs;                          // 表示当前位于ID段的指令是否是浮点运算型指令

    // lwc1
    assign stl_lwc1 = exe_m2fr & (i_fs&(exe_frn==fs) | i_ft&(exe_frn==ft)); // stall lwc1
    assign fwd_la = mem_m2fr & (mem_frn==fs);
    assign fwd_lb = mem_m2fr & (mem_frn==ft);

    // swc1
    assign id_m2fr = i_lwc1 & pc_ir_wen;            // fwmem
    assign swfp = i_swc1;                           // select signal
    assign fwd_f = swfp & e3_fw & (ft==e3_fn);      // e3->id
    assign fwd_fe = swfp & e2_fw & (ft==e2_fn);     // e3->exe
    assign stl_swc1 = swfp & e1_fw & (ft==e1_fn);   // stall swc1
endmodule