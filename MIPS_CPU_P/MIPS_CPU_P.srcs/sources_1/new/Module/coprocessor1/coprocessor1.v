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
// Description: 仅处理运算型浮点指令
// 
// Dependencies: coprocessor1
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module coprocessor1 #(parameter WIDTH=32, REGBITS=5)(
    input clk,
    input clrn,
    input ein1,                                 
    input ein2,
    input pc_ir_wen,                            // pc_ir_wen
    input ei_wen,
    input [WIDTH-1:0] id_instr,
    input id_m2fr,                              // 读存储写浮点寄存器信号(mem to float reg)
    input [REGBITS-1:0] id_rn,                  // iu mem to reg 寄存器号(f访存与iu访存的rn一样) 
    input [WIDTH-1:0] mem_mrd,                  // iu mem段的mem读数据(mem read data) 
    input [WIDTH-1:0] wb_mrd,                   // iu wb段的mem读数据(mem read data)
    output swfp,                                // swc1指令,选择dfb为mem写数据
    output fwd_f,                               // swc1 forward: e3->id
    output fwd_fe,                              // swc1 forward: e3->exe
    output [WIDTH-1:0] dfb,
    output [WIDTH-1:0] exe_d,                   // fpu exe段的计算结果(float data)
    output stl_fp,                              // stall 浮点运算型指令
    output stl_ds,                              // fdiv fsqrt
    output stl_lwc1,                            // stall lwc1
    output stl_swc1);                           // stall swc1

    // in: id_instr,exe_d,mem_mrd
    wire f_compu;                               // 表示当前位于ID段的指令是否是浮点运算型指令
    wire [REGBITS-1:0] fs,ft,fd;                // iu 解析f指令
    wire [2:0] fc;                              // iu 解析f指令得到运算控制码
    // 运算型float指令写浮点寄存器有关
    wire id_fw;                                 // id段写浮点寄存器信号
    wire id_ei_fw = ei_wen & id_fw;
    wire e1_fw,e2_fw,e3_fw;                     // e1,e2,e3段写浮点寄存器信号
    wire wb_fw;                                 // wb段写浮点寄存器信号
    wire [REGBITS-1:0] e1_fn,e2_fn,e3_fn;       // e1,e2,e3段写目标寄存器号
    wire [REGBITS-1:0] wb_fn;                   // wb段写目标寄存器号(运算型float指令)
    // wire [WIDTH-1:0] exe_d                   // fpu exe段的计算结果(float data)
    wire [WIDTH-1:0] wb_d;                      // wb段的浮点计算结果(float data)
    // 访存型float指令(lwc1)写浮点寄存器有关
    // in: id_rn,id_m2fr,mem_mrd, wb_mrd
    wire id_ei_m2fr = id_m2fr & ei_wen;
    reg exe_m2fr;
    reg mem_m2fr;
    reg wb_m2fr;
    reg [REGBITS-1:0] exe_frn;
    reg [REGBITS-1:0] mem_frn;
    reg [REGBITS-1:0] wb_frn;
    // bypass有关
    wire [WIDTH-1:0] qfa;                       // bypass有关数据
    wire [WIDTH-1:0] qfb;
    wire [WIDTH-1:0] fa;
    wire [WIDTH-1:0] fb;
    wire [WIDTH-1:0] dfa;
    // wire [WIDTH-1:0] dfb;
    wire fwd_la,fwd_lb,fwd_fa,fwd_fb;           // bypass选择器选择信号
    // wire fwd_f;
    // wire fwd_fe;

    // PC(无)
    // IF段(无)
    // FD流水寄存器(无)
    // ID段
    regfile2w#(WIDTH, REGBITS) f_rf(~clk,clrn,wb_d,wb_mrd,fs,ft,wb_fn,wb_frn,wb_fw,wb_m2fr,qfa,qfb);    // float regfile

    wire [5:0] op = id_instr[31:26];
    wire [5:0] func = id_instr[5:0];
    assign fs = id_instr[15:11];
    assign ft = id_instr[20:16];
    assign fd = id_instr[10:6];

    c1_control c1_cu(op,func,fs,ft,pc_ir_wen,stl_others,exe_m2fr,mem_m2fr,exe_frn,mem_frn,e1_fw,
        e2_fw,e3_fw,e1_fn,e2_fn,e3_fn,fc,swfp,fwd_f,fwd_fe,fwd_la,fwd_lb,fwd_fa,fwd_fb,id_fw,
        id_m2fr,stl_fp,stl_lwc1,stl_swc1,f_compu);
    
    mux2x32 fwd_fp_a(fa,exe_d,fwd_fa,fa);
    mux2x32 fwd_fp_b(fb,exe_d,fwd_fb,fb);
    mux2x32 fwd_lwc1_a(qfa,mem_mrd,fwd_la,dfa);
    mux2x32 fwd_lwc1_b(qfb,mem_mrd,fwd_lb,dfb);

    // DE流水寄存器
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            exe_m2fr<=0;    exe_frn<=0;
        end else begin
            exe_m2fr<=id_ei_m2fr;  exe_frn<=id_rn;
        end
    end
    // EXE段
    fpu#(WIDTH,REGBITS) fu(clk,clrn,dfa,dfb,fd,fc,id_ei_fw,ein1,ein2,
        exe_d,wb_d,e1_fn,e2_fn,e3_fn,wb_fn,e1_fw,e2_fw,e3_fw,wb_fw,stl_ds); // fpu前面一部分还是属于ID段的

    // EM流水寄存器
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            mem_m2fr<=0;    mem_frn<=0;
        end else begin
            mem_m2fr<=exe_m2fr; mem_frn<=exe_frn;
        end
    end
    // MEM段(无)

    // MW流水寄存器
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            wb_m2fr<=0;     wb_frn<=0;
        end else begin
            wb_m2fr<=mem_m2fr;  wb_frn<=mem_frn;
        end
    end
    // WB段(无)
    
endmodule