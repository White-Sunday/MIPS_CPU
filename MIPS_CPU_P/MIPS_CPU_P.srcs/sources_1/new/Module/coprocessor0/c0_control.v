`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: c0_control
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


module c0_control #(parameter WIDTH=32)(
    input clk,
    input clrn,
    input id_intr,
    input [WIDTH-1:0] id_instr,
    input [WIDTH-1:0] id_sta,
    input pc_ir_wen,
    input exe_is_bj,
    input exe_ovr,
    input exe_cancel,
    input mem_is_bj,
    input mem_ovr,
    output ei_wen,                      // 写信号 & ei_wen
    output ei_bj,                       // ei_pc_src = ei_bj ? 2'b00 : pc_src
    output ei_stl,                      // ei_pc_ir_wen = pc_ir_wen | ei_stl
    output [1:0] pc_sel,
    output id_is_bj,
    output id_ov_en,
    output id_cancel,
    output [1:0] id_mfc0,
    output mtc0,
    output exc_int,
    output [1:0] epc_sel,
    output [WIDTH-1:0] cause,
    output wcau,
    output wsta,
    output wepc,
    output inta);

    // 指令译码
    wire c0_type;                       // cp0有关指令
    wire i_syscall;                     // 为系统调用指令
    wire i_mfc0;                        // 为mfc0指令
    wire i_mtc0;                        // 为mtc0指令
    wire i_eret;                        // 为eret指令
    wire unim_instr;                    // 未实现指令(unimplemented)
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
    // 异常/中断指令有关信号
    assign c0_type = (op == 6'b010000);
    assign i_mfc0 = c0_type & (rs == 5'b00000);
    assign i_mtc0 = c0_type & (rs == 5'b00100);
    assign i_eret = c0_type & (rs == 5'b10000) & (func == 6'b011000);
    assign i_syscall = r_type & (func == 6'b001100);
    wire rd_is_sta = (rd == 5'd12);
    wire rd_is_cau = (rd == 5'd13);
    wire rd_is_epc = (rd == 5'd14);
    wire ei_int = id_sta[0] & id_intr;                      // 发生中断事件
    wire ei_sys = id_sta[1] & i_syscall;                    // 发生系统调用异常
    wire ei_unim = id_sta[2] & unim_instr;                  // 发生未实现指令异常(unimplemented)
    wire ei_ovr = exe_ovr;                                  // 发生溢出
    // 未实现指令
    assign unim_instr = ~(i_mfc0 | i_mtc0 | i_eret | i_syscall |
        i_add | i_sub | i_and | i_or | i_xor | i_sll | i_srl |
        i_jr | i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_beq |
        i_bne | i_lui | i_j | i_jal);
    
    // // 指令取消有关信号
    // assign id_cancel = exc_int | i_eret;                                // 异常/中断处理总是删除后面那条指令，eret指令也需要删除后面一条
    // assign id_ei_wmem = id_wmem & ~exe_cancel & ~exe_ovr & ~mem_ovr;
    // assign id_ei_wreg = id_wreg & ~exe_cancel & ~exe_ovr & ~mem_ovr;    // 要加上i_mfc0指令
    // assign ei_pc_src = (exe_cancel | exe_ovr | mem_ovr)? 2'b00 : pc_src;
    // assign ei_pc_ir_wen = pc_ir_wen | (id_cancel | exe_cancel | exe_ovr | mem_ovr); // 正在触发的流水阻塞需要取消+需要被取消的指令不能引发流水阻塞
    // 指令取消有关信号
    assign id_cancel = exc_int | i_eret;                                // 异常/中断处理总是删除后面那条指令，eret指令也需要删除后面一条
    assign ei_wen = ~exe_cancel & ~exe_ovr & ~mem_ovr;
    assign ei_bj = exe_cancel | exe_ovr | mem_ovr; 
    assign ei_stl = id_cancel | exe_cancel | exe_ovr | mem_ovr;         // 正在触发的流水阻塞需要取消+需要被取消的指令不能引发流水阻
    
    // cp0寄存器更新有关信号
    // exc_int指出发生异常/中断的同时,控制sta寄存器的更新
    assign exc_int = ei_int | ei_sys | ei_unim | ei_ovr;    // 出现异常/中断
    // epc sel
    assign id_is_bj = i_beq | i_bne | i_jr | i_j | i_jal;  // 拥有延迟槽的BranchJump指令
    // is_bj也可以用来判断是否处于延迟槽(上一条指令是否是bj)
    // epc sel: id is_bj    exe is_bj   mem is_bj   others 
    // ei_int   PCD(01)     PC(00)      PC(00)      PC(00)
    // ei_sys   Impossible  Not allowed PCD(01)     PCD(01)
    // ei_unim  Impossible  Not allowed PCD(01)     PCD(01)
    // ei_ovr   PCE(10)     Impossible  PCM(11)     PCE(10)
    // 异常/中断时如果指令(ID段)正在触发流水阻塞(pc_ir_wen=0),也需要保存PCD
    assign epc_sel[0] = ei_int & ~pc_ir_wen | ei_int & id_is_bj | ei_sys | ei_unim | ei_ovr & mem_is_bj;
    assign epc_sel[1] = ei_ovr;
    // cause
    // exccode: 00-int 01-sys 10-unim 11-ovr 
    wire [1:0] exccode;                         // cause寄存器的exccode
    assign exccode[0] = i_syscall | ei_ovr;     // 不是ei_sys | ei_ovr
    assign exccode[1] = unim_instr | ei_ovr;    // 不是ei_unim | ei_ovr
    assign cause = {exe_is_bj,27'h0,exccode,2'b00}; // 处于延迟槽时,BD为1
    // 异常/中断需要更新cp0寄存器,mtc0指令需要更新指定cp0寄存器,eret指令需要右移sta
    assign mtc0 = i_mtc0;
    assign wsta = exc_int | mtc0 & rd_is_sta | i_eret;
    assign wcau = exc_int | mtc0 & rd_is_cau;
    assign wepc = exc_int | mtc0 & rd_is_epc;

    // mfc0: 00-default 01-sta 10-cau 11-epc
    assign id_mfc0[0] = i_mfc0 & rd_is_sta | i_mfc0 & rd_is_epc;
    assign id_mfc0[1] = i_mfc0 & rd_is_cau | i_mfc0 & rd_is_epc;
    
    // pc_sel: 00-npc 01-epc 10-ei_base 11-x
    assign pc_sel[0] = i_eret;
    assign pc_sel[1] = exc_int;
    
    // id_ov_en
    wire arith = i_add | i_sub | i_addi;
    assign id_ov_en = id_sta[3] & arith;            // 溢出使能
    
    // 中断响应信号 inta
    assign inta = ei_int;                           // 对于中断进行立刻响应
endmodule