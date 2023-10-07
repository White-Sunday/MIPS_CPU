`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: coprocessor0
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


module coprocessor0 #(parameter WIDTH=32)(
    input clk,
    input clrn,
    input intr,
    input [WIDTH-1:0] pc,
    input [WIDTH-1:0] instr,
    input [1:0] pc_src,
    input [WIDTH-1:0] next_pc,
    input pc_ir_wen,
    input [WIDTH-1:0] id_b,
    input id_wreg,
    input id_wmem,
    input ov,
    input exe_wreg,
    input [WIDTH-1:0] exe_alu,
    output [1:0] ei_pc_src,         // 经过cp0的处理,可以取消BJ指令的动作------------------取消1
    output [WIDTH-1:0] ei_next_pc,  // 考虑异常/中断后的next_npc
    output id_ei_wreg,              // 经过cp0的处理的id_wreg,可以取消指令的写寄存器动作----取消2-1
    output id_ei_wmem,              // 经过cp0的处理的id_wmem,可以取消指令的写存储器动作----取消2-2
    output ei_pc_ir_wen,            // 经过cp0的处理,可以取消指令可能引发的流水阻塞---------取消3
    output exe_ei_wreg,             // 经过cp0的处理的exe_wreg,可以取消当前指令的执行
    output [WIDTH-1:0] exe_ei_alu,  // 经过cp0的处理的exe_alu,即取出的sta等寄存器
    output inta);                   // 中断响应信号(interrupt aknowledgement)

    parameter ei_base = 32'h00000008;   // 异常/中断处理服务程序地址
    
    // IF段信号 
    // in: intr,pc,instr,pc_src,next_pc
    // out:ei_pc_src,ei_next_pc
    // ID段信号
    // in: pc_ir_wen,id_b,id_wreg,id_wmem
    // out:id_ei_wreg,id_ei_wmem
    wire id_intr;                       // ID段的intr
    wire [WIDTH-1:0] id_pc;             // ID段的pc
    wire [WIDTH-1:0] id_instr;          // ID段的instr
    wire [1:0] pc_sel;                  // ei_next_pc的选择信号
    wire id_is_bj;                      // ID段得到的是否为分支指令信号
    wire id_ov_en;                      // ID段得到的溢出使能信号
    wire id_cancel;                     // ID段得到的指令取消信号
    wire [1:0] id_mfc0;                 // move from cp0指令用于选择exe段的pc8,sta,cau与epc做为exe_alu
    wire mtc0;                          // move to cp0信号
    wire [1:0] epc_sel;                 // 用于epc_in0的选择信号
    wire [WIDTH-1:0] cause;             // cp0用于更新的cause内容
    wire [WIDTH-1:0] sta_lr;            // sta左移或右移4位的结果
    wire [WIDTH-1:0] epc_in0;
    wire [WIDTH-1:0] cau_in;            // cause寄存器的data in
    wire [WIDTH-1:0] sta_in;            // status寄存器的data in
    wire [WIDTH-1:0] epc_in;            // epc寄存器的data in
    wire exc_int;                       // 检测到异常/中断信号,用来取消stall,否则无法跳转到中断服务
    wire [WIDTH-1:0] id_cau;            // cause寄存器的内容
    wire [WIDTH-1:0] id_sta;            // status寄存器的内容 IM[3:0]:ov,unimpl,sys,int;在程序里设置其初值,并限制嵌套次数
    wire [WIDTH-1:0] id_epc;            // epc寄存器的内容
    wire wcau;                          // cause寄存器写信号
    wire wsta;                          // status寄存器写信号
    wire wepc;                          // epc寄存器写信号
    // EXE段信号
    // in: ov,exe_wreg,exe_alu
    // out:exe_id_wreg,exe_ei_alu
    reg [WIDTH-1:0] exe_cau;
    reg [WIDTH-1:0] exe_sta;
    reg [WIDTH-1:0] exe_epc;
    reg [WIDTH-1:0] exe_pc;
    reg exe_is_bj;
    reg exe_ov_en;
    reg exe_cancel;
    reg [1:0] exe_mfc0;
    wire exe_ovr;
    // MEM段信号
    reg [WIDTH-1:0] mem_pc;
    reg mem_is_bj;
    reg mem_ovr;
    
    // PC(无)
    // IF段(无)
    mux4x32 ei_npc_cntr(next_pc,id_epc,ei_base,32'h0,pc_sel,ei_next_pc);
    // FD流水寄存器
    dffe32 fd_pc(pc,clk,clrn,ei_pc_ir_wen,id_pc);
    dffe32 fd_instr(instr,clk,clrn,ei_pc_ir_wen,id_instr);
    dff fd_intr(intr,clk,clrn,id_intr);
    // ID段
    // c0 cu
    c0_control c0_cu(clk,clrn,pc_src,id_wreg,id_wmem,id_intr,id_instr,id_sta,pc_ir_wen,exe_is_bj,
        exe_ovr,exe_cancel,mem_is_bj,mem_ovr,ei_pc_src,pc_sel,id_ei_wreg,id_ei_wmem,
        id_is_bj,id_ov_en,id_cancel,id_mfc0,ei_pc_ir_wen,mtc0,exc_int,epc_sel,cause,wcau,wsta,wepc,inta);
    // status和epc
    mux2x32 sta_left_right({4'h0,id_sta[31:4]},{id_sta[27:0],4'h0},exc_int,sta_lr);
    mux4x32 epc_src(pc,id_pc,exe_pc,mem_pc,epc_sel,epc_in0);
    // cp0 register data in
    mux2x32 cau_mux(cause,id_b,mtc0,cau_in);
    mux2x32 sta_mux(sta_lr,id_b,mtc0,sta_in);
    mux2x32 epc_mux(epc_in0,id_b,mtc0,epc_in);
    // cp0 register
    dffe32 c0_cause(cau_in,clk,clrn,wcau,id_cau);
    dffe32 c0_status(sta_in,clk,clrn,wsta,id_sta);
    dffe32 c0_epc(epc_in,clk,clrn,wepc,id_epc);
    // DE流水寄存器
    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin
            exe_cau <= 0;
            exe_sta <= 0;
            exe_epc <= 0;
            exe_pc <= 0;
            exe_is_bj <= 0;
            exe_ov_en <= 0;
            exe_cancel <= 0;
            exe_mfc0 <= 0;
        end else begin
            exe_cau <= id_cau;
            exe_sta <= id_sta;
            exe_epc <= id_epc;
            exe_pc <= id_pc;
            exe_is_bj <= id_is_bj;
            exe_ov_en <= id_ov_en;
            exe_cancel <= id_cancel;
            exe_mfc0 <= id_mfc0;
        end
    end
    // EXE段
    assign exe_ovr = exe_ov_en & ov;
    assign exe_ei_wreg = ~exe_ovr & exe_wreg;   // 溢出异常,在EXE段取消wreg信号来取消当前异常指令
    mux4x32 ei_alu_sel(exe_alu,exe_sta,exe_cau,exe_epc,exe_mfc0,exe_ei_alu);
    // EM流水寄存器 
    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin
            mem_pc <=0 ;
            mem_is_bj <= 0;
            mem_ovr <= 0;
        end else begin
            mem_pc <= exe_pc;
            mem_is_bj <= exe_is_bj;
            mem_ovr <= exe_ovr;
        end
    end
    
    // MEM段(无)
    // MW流水寄存器(无)
    // WB段(无)
endmodule