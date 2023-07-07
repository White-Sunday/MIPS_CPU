`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: pipe_id
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


module pipe_id #(parameter WIDTH=32, REGBITS=5)(
    input clk,
    input clrn,
    input [WIDTH-1:0] id_pc4,   // ID段的pc+4
    input [WIDTH-1:0] id_instr, // ID段的指令
    input [WIDTH-1:0] wb_rwd,   // WB段得到的写入寄存器数据(reg write data)
    input [WIDTH-1:0] exe_alu,  // EXE段得到的alu计算结果
    input [WIDTH-1:0] mem_alu,  // MEM段的alu计算结果
    input [WIDTH-1:0] mem_mrd,  // MEM段得到的存储器读数据
    input [REGBITS-1:0] exe_rn, // EXE段得到的写目标寄存器地址
    input [REGBITS-1:0] mem_rn, // MEM段的写目标寄存器地址
    input [REGBITS-1:0] wb_rn,  // WB段的写目标寄存器地址
    input exe_wreg,             // EXE段的寄存器写信号
    input exe_m2reg,            // EXE段的存储到寄存器数据传递信号
    input mem_wreg,             // MEM段的存储器写信号
    input mem_m2reg,            // MEM段的存储到寄存器数据传递信号
    input wb_wreg,              // WB段的寄存器写信号
    output [WIDTH-1:0] id_a,    // ID段得到的alu操作数a/jr分支目标
    output [WIDTH-1:0] id_b,    // ID段得到的alu操作数b
    output [WIDTH-1:0] id_imm,  // ID段得到的imm(一般的imm和shift指令的shamt)
    output [WIDTH-1:0] b_pc,    // 条件分支目标branch_pc(beq,bne)
    output [WIDTH-1:0] j_pc,    // 无条件分支目标jump_pc(j,jal)
    output [WIDTH-1:0] id_rn,   // ID段得到的写目标寄存器地址
    output [1:0] pc_src,    // next pc选择信号
    output pc_ir_wen,       // pc,if/id流水寄存器写使能信号,通过它可以完成IF段和ID段的流水阻塞(停止更新)
    output id_wreg,         // 寄存器写信号
    output id_m2reg,        // 存储到寄存器数据传递信号
    output id_wmem,         // 存储器写信号
    output id_jal,          // 表明当前指令是jal
    output [3:0] id_aluc,   // alu操作控制信号 alu control
    output id_shift,        // 为1代表alu的a操作数是shift,一般用于shift类指令
    output id_alu_imm);     // 为1代表alu的b操作数是imm,一般用于i型指令、访存指令地址计算

    wire [5:0] op = id_instr[31:26];
    wire [4:0] rs = id_instr[25:21];
    wire [4:0] rt = id_instr[20:16];
    wire [4:0] rd = id_instr[15:11];
    wire [5:0] func = id_instr[5:0];
    wire [15:0] imm = id_instr[15:0];
    wire [25:0] j_addr = id_instr[25:0];

    wire reg_dest_sel;          // 为0时,写目标寄存器地址为rd;为1时,写目标寄存器地址为rt
    wire sign_ext;              // 是否符号位拓展
    wire [WIDTH-1:0] qa,qb;
    wire [1:0] fwd_a,fwd_b;     // forward a,b 得到id_a,id_b的前递选择信号
    wire rs_rt_equ = ~|(id_a^id_b);     // reg[rs]==reg[rt] 年轻了,这里也要考虑到前递设计

    // 寄存器组
    regfile#(WIDTH, REGBITS) rf(~clk,clrn,wb_rwd,rs,rt,wb_rn,wb_wreg,qa,qb);    // ~clk实现clk下降沿写寄存器,以解决一部分数据冲突

    // control unit
    control#(WIDTH) cu(op,func,rs,rt,exe_rn,mem_rn,exe_wreg,exe_m2reg,mem_wreg,mem_m2reg,
        rs_rt_equ,id_aluc,pc_src,fwd_a,fwd_b,id_wreg,id_m2reg,id_wmem,
        id_alu_imm,id_shift,id_jal,reg_dest_sel,sign_ext,pc_ir_wen);

    // rn选择
    mux2x5 dest_reg(rd,rt,reg_dest_sel,id_rn);      // 选择dest reg

    // 数据前递
    mux4x32 sel_a(qa,exe_alu,mem_alu,mem_mrd,fwd_a,id_a);   // 选择id_a
    mux4x32 sel_b(qb,exe_alu,mem_alu,mem_mrd,fwd_b,id_b);   // 选择id_b

    // PC计算与id_imm
    wire [15:0] sign_16 = {16{sign_ext&id_instr[15]}};     // 高位拓展部分
    assign id_imm = {sign_16,imm};                      // 得到id_mem
    wire [WIDTH-1:0] b_offset = {id_imm[29:0],2'b00};   // branch offset
    assign j_pc = {id_pc4[31:28],j_addr,2'b00};         // 得到j_pc
    cla32 b_pc_adr(id_pc4,b_offset,1'b0,b_pc);          // 得到b_pc: adr for branch pc

endmodule
