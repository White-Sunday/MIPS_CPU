`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: control
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


module control #(parameter WIDTH=32)(
    input [5:0] op,
    input [5:0] func,
    input [4:0] rs,             // 前递设计所需信号
    input [4:0] rt,
    input [4:0] exe_rn,
    input [4:0] mem_rn,
    input exe_wreg,
    input exe_m2reg,
    input mem_wreg,
    input mem_m2reg,
    input rs_rt_equ,            // 用于beq和bne的rs_rt比较信号
    output [3:0] id_aluc,       // alu操作控制信号
    output [1:0] pc_src,        // next pc选择信号
    output reg [1:0] fwd_a,     // 前递选择信号
    output reg [1:0] fwd_b,
    output id_wreg,             // 控制信号
    output id_m2reg,
    output id_wmem,
    output id_alu_imm,
    output id_shift,
    output id_jal,
    output reg_dest_sel,
    output sign_ext,
    output pc_ir_wen);

    // 指令译码
    wire rtype = (op == 6'b000000);                 // R型指令
    wire i_add = rtype & (func == 6'b100000);       //  这里的i_前缀指的是instruction
    wire i_sub = rtype & (func == 6'b100010);
    wire i_and = rtype & (func == 6'b100100);
    wire i_or = rtype & (func == 6'b100101);
    wire i_xor = rtype & (func == 6'b100110);
    wire i_sll = rtype & (func == 6'b000000);
    wire i_srl = rtype & (func == 6'b000010);
    wire i_sra = rtype & (func == 6'b000011);
    wire i_jr = rtype & (func == 6'b001000);
    wire i_addi = (op == 6'b001000);                // I型指令
    wire i_andi = (op == 6'b001100);
    wire i_ori = (op == 6'b001101);
    wire i_xori = (op == 6'b001110);
    wire i_lw = (op == 6'b100011);
    wire i_sw = (op == 6'b101011);
    wire i_beq = (op == 6'b000100);
    wire i_bne = (op == 6'b000101);
    wire i_lui = (op == 6'b001111);
    wire i_j = (op == 6'b000010);                   // J型指令
    wire i_jal = (op == 6'b000011);

    // 指令是否用到rs
    wire i_rs = i_add | i_sub | i_and | i_or | i_xor | i_jr |
        i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_beq | i_bne;
    // 指令是否用到rt
    wire i_rt = i_add | i_sub | i_and | i_or | i_xor | i_jr | i_sll | i_srl | i_sra |
        i_sw | i_beq | i_bne;
    
    // stall 即针对IF段和ID段的阻塞信号,用于停止PC和IF/ID流水寄存器的更新
    // 目前只有lw会导致阻塞,注意exe_rn==0不用阻塞,因为lw到0寄存器是没有意义的
    wire stall = exe_wreg & exe_m2reg & (exe_rn!=0) & 
        ((i_rs & (rs==exe_rn)) | (i_rt & (rt==exe_rn)));
    assign pc_ir_wen = ~stall;  // stall信号取反就是pc_ir_wen,实现阻塞

    always @ (exe_wreg,exe_m2reg,exe_rn,mem_wreg,mem_m2reg,mem_rn,rs,rt) begin
        fwd_a = 2'b00;      // 默认: 没有冲突
        if (exe_wreg & (exe_rn!=0) & (rs==exe_rn) & ~exe_m2reg) begin
            fwd_a = 2'b01;  // 选择exe_alu
        end else begin
            if (mem_wreg & (mem_rn!=0) & (rs==mem_rn) & ~mem_m2reg) begin
                fwd_a = 2'b10;  // 选择mem_alu
            end else begin
                if (mem_wreg & (mem_rn!=0) & (rs==mem_rn) & mem_m2reg) begin
                    fwd_a = 2'b11;  // 选择mem_mrd
                end
            end
        end

        fwd_b = 2'b00;
        if (exe_wreg & (exe_rn!=0) & (rt==exe_rn) & ~exe_m2reg) begin
            fwd_b = 2'b01;  // 选择exe_alu
        end else begin
            if (mem_wreg & (mem_rn!=0) & (rt==mem_rn) & ~mem_m2reg) begin
                fwd_b = 2'b10;  // 选择mem_alu
            end else begin
                if (mem_wreg & (mem_rn!=0) & (rt==mem_rn) & mem_m2reg) begin
                    fwd_b = 2'b11;  // 选择mem_mrd
                end
            end
        end
    end

    // 控制信号
    wire wreg_org = i_add | i_sub | i_and | i_or | i_xor | i_sll | i_srl |
        i_sra | i_addi | i_andi | i_ori | i_xori | i_lw | i_lui | i_jal;
    wire wmem_org = i_sw;
    // 通过取消对reg,mem的写信号,来解决lw命令引发stall导致的后续指令二次执行问题
    assign id_wreg = wreg_org & ~stall; // original_wreg & ~stall 
    assign id_wmem = wmem_org & ~stall; // original_wreg & ~stall
    assign reg_dest_sel = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui;  // I型指令的写目标寄存器为rt
    assign id_jal = i_jal;
    assign id_m2reg = i_lw;
    assign id_shift = i_sll | i_srl | i_sra;
    assign id_alu_imm = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui | i_sw;
    // 下面为什么还要放beq和bne呢?我认为是beq和bne含有计算动作,虽然流水设计里使用独立器件提前到ID段完成,
    // 但是为了避免对流水的潜在破坏可能,还是要把正常的计算动作走一遍
    assign sign_ext = i_addi | i_lw | i_sw | i_beq | i_bne;     // 不过这里的i_beq | i_bne可能有点多余
    assign id_aluc[3] = i_sra;
    assign id_aluc[2] = i_sub | i_or | i_srl | i_sra | i_ori | i_lui;
    assign id_aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_beq | i_bne | i_lui;
    assign id_aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori;
    // 00-pc4 01-b_pc 10-r_pc 11-j_pc
    assign pc_src[1] = i_jr | i_j | i_jal;
    assign pc_src[0] = (i_beq & rs_rt_equ) | (i_bne & ~rs_rt_equ) | i_j | i_jal;
endmodule