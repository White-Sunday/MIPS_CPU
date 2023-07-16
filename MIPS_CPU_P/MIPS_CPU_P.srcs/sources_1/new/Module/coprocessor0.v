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
    input id_intr,
    input [WIDTH-1:0] id_instr,
    input [WIDTH-1:0] next_pc,
    input [WIDTH-1:0] pc,
    input [WIDTH-1:0] id_pc,
    input [WIDTH-1:0] exe_pc,
    input [WIDTH-1:0] mem_pc,
    input [WIDTH-1:0] id_b,
    input [1:0] pc_src,             // 传入cu得到的prc_src
    input exe_is_bj,
    input mem_is_bj,
    input exe_cancel,
    input exe_ovr,
    input mem_ovr,
    input id_wreg,
    input id_wmem,
    output [WIDTH-1:0] ei_next_pc,  // 考虑异常/中断后的next_npc
    output id_ei_wreg,              // 经过cp0的处理,可以取消当前指令的执行
    output id_ei_wmem,              // 经过cp0的处理,可以取消当前指令的执行
    output id_is_bj,                // 是否是Branch或Jump指令
    output id_ov_en,                // 溢出检测使能信号
    output id_cancel,               // 指令取消信号
    output [WIDTH-1:0] id_cau,      // cause寄存器的内容
    output [WIDTH-1:0] id_sta,      // status寄存器的内容 IM[3:0]:ov,unimpl,sys,int;在程序里设置其初值,并限制嵌套次数
    output [WIDTH-1:0] id_epc,      // epc寄存器的内容
    output [1:0] id_mfc0,           // move from cp0指令用于选择exe段的pc8,sta,cau与epc做为exe_alu
    output [1:0] ei_pc_src,         // 经过cp0的处理,可以取消当前BJ指令的执行
    output inta);                   // 中断响应

    parameter ei_base = 32'h00000008;   // 异常/中断处理服务程序地址

    // pc选择有关信号
    wire [1:0] pc_sel;                  // ei_next_pc的选择信号
    wire [1:0] epc_sel;                 // 用于epc_in0的选择信号
    // cp0寄存器有关信号
    wire [1:0] exccode;                 // cause寄存器的exccode
    wire [WIDTH-1:0] cause;             // cp0用于更新的cause内容
    wire [WIDTH-1:0] sta_lr;            // sta左移或右移4位的结果
    wire [WIDTH-1:0] epc_in0;
    wire [WIDTH-1:0] cau_in;            // cause寄存器的data in
    wire [WIDTH-1:0] sta_in;            // status寄存器的data in
    wire [WIDTH-1:0] epc_in;            // epc寄存器的data in
    wire wcau;                          // cause寄存器写信号
    wire wsta;                          // status寄存器写信号
    wire wepc;                          // epc寄存器写信号
    // 异常/中断处理控制有关信号
    wire exc_int;                       // 检测到异常/中断信号
    wire ei_int;                        // 发生中断事件
    wire ei_sys;                        // 发生系统调用异常
    wire ei_unim;                       // 发生未实现指令异常(unimplemented)
    wire ei_ovr;                        // 发生溢出
    wire unim_instr;                    // 未实现指令(unimplemented)
    wire rd_is_sta;
    wire rd_is_cau;
    wire rd_is_epc;
    wire mtc0;                          // move to cp0信号

    // 指令译码
    wire c0_type;                       // cp0有关指令
    wire i_syscall;                     // 为系统调用指令
    wire i_mfc0;                        // 为mfc0指令
    wire i_mtc0;                        // 为mtc0指令
    wire i_eret;                        // 为eret指令
    // 这里没有直接从cu那里牵线过来,是为了模块间解耦
    wire [5:0] op = id_instr[31:26];
    wire [5:0] func = id_instr[5:0];
    wire [4:0] rs = id_instr[25:21];
    wire [4:0] rd = id_instr[15:11];
    wire r_type = (op == 6'b000000);
    wire i_add = r_type & (func == 6'b100000);
    wire i_sub = r_type & (func == 6'b100010);
    wire i_and = r_type & (func == 6'b100100);
    wire i_or = r_type & (func == 6'b100101);
    wire i_xor = r_type & (func == 6'b100110);
    wire i_sll = r_type & (func == 6'b000000);
    wire i_srl = r_type & (func == 6'b000010);
    wire i_sra = r_type & (func == 6'b000011);
    wire i_jr = r_type & (func == 6'b001000);
    wire i_addi = (op == 6'b001000);
    wire i_andi = (op == 6'b001100);
    wire i_ori = (op == 6'b001101);
    wire i_xori = (op == 6'b001110);
    wire i_lw = (op == 6'b100011);
    wire i_sw = (op == 6'b101011);
    wire i_beq = (op == 6'b000100);
    wire i_bne = (op == 6'b000101);
    wire i_lui = (op == 6'b001111);
    wire i_j = (op == 6'b000010);
    wire i_jal = (op == 6'b000011);
    // 异常/中断有关指令
    assign c0_type = (op == 6'b010000);
    assign i_mfc0 = c0_type & (rs == 5'b00000);
    assign i_mtc0 = c0_type & (rs == 5'b00100);
    assign i_eret = c0_type & (rs == 5'b10000) & (func == 6'b011000);
    assign i_syscall = r_type & (func == 6'b001100);
    // 未实现指令
    assign unim_instr = ~(i_mfc0 | i_mtc0 | i_eret | i_syscall |
        i_add | i_sub | i_and | i_or | i_xor | i_sll | i_srl |
        i_jr | i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_beq |
        i_bne | i_lui | i_j | i_jal);

    assign ei_int = id_sta[0] & id_intr;
    assign ei_sys = id_sta[1] & i_syscall;
    assign ei_unim = id_sta[2] & unim_instr;
    assign ei_ovr = exe_ovr;
    assign exc_int = ei_int | ei_sys | ei_unim | ei_ovr;    // 出现异常/中断

    // 任务一: 取消对应指令的执行
    assign id_cancel = exc_int | i_eret;            // 异常/中断处理总是删除后面那条指令，eret指令也需要删除后面一条
    assign id_ei_wmem = id_wmem & ~exe_cancel & ~exe_ovr & ~mem_ovr;
    assign id_ei_wreg = id_wreg & ~exe_cancel & ~exe_ovr & ~mem_ovr; // 要加上i_mfc0指令
    assign ei_pc_src = (exe_cancel | exe_ovr | mem_ovr)? 2'b00 : pc_src;

    // 任务二: cp0寄存器更新
    // cause
    assign id_is_bj = i_beq | i_bne | i_jr | i_j | i_jal;  // 拥有延迟槽的BranchJump指令
    // is_bj也可以用来判断是否处于延迟槽(上一条指令是否是bj)
    // epc sel: id is_bj    exe is_bj   mem is_bj   others 
    // ei_int   PCD(01)     PC(00)      PC(00)      PC(00)
    // ei_sys   Impossible  Not allowed PCD(01)     PCD(01)
    // ei_unim  Impossible  Not allowed PCD(01)     PCD(01)
    // ei_ovr   PCE(10)     Impossible  PCM(11)     PCE(10)
    assign epc_sel[0] = ei_int & id_is_bj | ei_sys | ei_unim | ei_ovr & mem_is_bj;
    assign epc_sel[1] = ei_ovr;
    // exccode: 00-int 01-sys 10-unim 11-ovr 
    assign exccode[0] = i_syscall | ei_ovr;     // 不是ei_sys | ei_ovr
    assign exccode[1] = unim_instr | ei_ovr;    // 不是ei_unim | ei_ovr
    assign cause = {exe_is_bj,27'h0,exccode,2'b00}; // 处于延迟槽时,BD为1
    // status和epc
    mux2x32 sta_left_right({4'h0,id_sta[31:4]},{id_sta[27:0],4'h0},exc_int,sta_lr);
    mux4x32 epc_src(pc,id_pc,exe_pc,mem_pc,epc_sel,epc_in0);
    // cp0 register data in
    assign mtc0 = i_mtc0;
    mux2x32 cau_mux(cause,id_b,mtc0,cau_in);
    mux2x32 sta_mux(sta_lr,id_b,mtc0,sta_in);
    mux2x32 epc_mux(epc_in0,id_b,mtc0,epc_in);
    // cp0寄存器更新控制信号
    // 异常/中断需要更新cp0寄存器,mtc0指令需要更新指定cp0寄存器,eret指令需要右移sta
    assign wsta = exc_int | mtc0 & rd_is_sta | i_eret;
    assign wcau = exc_int | mtc0 & rd_is_cau;
    assign wepc = exc_int | mtc0 & rd_is_epc;
    assign rd_is_sta = (rd == 5'd12);
    assign rd_is_cau = (rd == 5'd13);
    assign rd_is_epc = (rd == 5'd14);
    // cp0 register
    dffe32 c0_cause(cau_in,clk,clrn,wcau,id_cau);
    dffe32 c0_status(sta_in,clk,clrn,wsta,id_sta);
    dffe32 c0_epc(epc_in,clk,clrn,wepc,id_epc);

    // 任务三: 转到异常/中断处理服务程序地址BASE
    // pc sel: 00-npc 01-epc 10-ei_base 11-x
    assign pc_sel[0] = i_eret;
    assign pc_sel[1] = exc_int;
    mux4x32 ei_npc_cntr(next_pc,id_epc,ei_base,32'h0,pc_sel,ei_next_pc);

    // EXE段用到信号
    wire arith = i_add | i_sub | i_addi;
    assign id_ov_en = id_sta[3] & arith;            // 溢出使能
    // mfc0: 00-default 01-sta 10-cau 11-epc
    assign id_mfc0[0] = i_mfc0 & rd_is_sta | i_mfc0 & rd_is_epc;
    assign id_mfc0[1] = i_mfc0 & rd_is_cau | i_mfc0 & rd_is_epc;

    // 中断响应信号
    assign inta = ei_int;                           // 对于中断进行立刻响应
endmodule