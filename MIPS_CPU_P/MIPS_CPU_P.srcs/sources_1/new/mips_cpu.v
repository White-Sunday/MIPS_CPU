`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/01 14:04:34
// Design Name: 
// Module Name: mips_cpu
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


module mips_cpu #(parameter WIDTH=32, ADDR=32, REGBITS=5)(
    input clk,                          // 时钟
    input clrn,                         // 复位信号
    output [WIDTH-1:0] pc,
    output [WIDTH-1:0] id_instr,        // ID段的指令
    output [WIDTH-1:0] exe_alu,         // EXE段得到的alu计算结果
    output [WIDTH-1:0] mem_alu,         // MEM段的alu计算结果
    output [WIDTH-1:0] wb_rwd);         // WB段得到的写入寄存器数据(reg write data)

    // 针对五段之间传递的信号(即用于流水寄存器的信号)作了前缀处理以相互区分
    // IF段信号 前缀:无
    wire [WIDTH-1:0] pc4;               // IF段得到的pc+4
    wire [WIDTH-1:0] instr;             // IF段得到的instr
    wire [WIDTH-1:0] next_pc;

    // ID段信号 前缀:id_(这一段也有些无前缀的信号,主要是pc有关信号,传回IF段)
    wire [WIDTH-1:0] id_pc4;            // ID段的pc+4
    wire [WIDTH-1:0] id_instr;          // ID段的instr
    wire [WIDTH-1:0] id_a;              // ID段得到的alu操作数a/jr分支目标
    wire [WIDTH-1:0] id_b;              // ID段得到的alu操作数b
    wire [WIDTH-1:0] id_imm;            // ID段得到的imm(一般的imm和shift指令的shamt)
    wire [WIDTH-1:0] b_pc;              // 条件分支目标branch_pc(beq,bne)
    wire [WIDTH-1:0] j_pc;              // 无条件分支目标jump_pc(j,jal)
    wire [REGBITS-1:0] id_rn;           // ID段得到的写目标寄存器地址

    wire [1:0] pc_src;                  // next pc选择信号
    wire pc_ir_wen;                     // pc,if/id流水寄存器写使能信号,通过它可以完成IF段和ID段的流水阻塞(停止更新)
    wire id_wreg;                       // ID段得到的寄存器写信号
    wire id_m2reg;                      // ID段得到的存储到寄存器数据传递信号
    wire id_wmem;                       // ID段得到的存储器写信号
    wire id_jal;                        // ID段得到的jal信号(表明当前指令是jal)
    wire [3:0] id_aluc;                 // ID段得到的alu操作控制信号 alu control
    wire id_shift;                      // ID段得到的shift信号(为1代表alu的a操作数是shift，一般用于shift类指令)
    wire id_alu_imm;                    // ID段得到的alu_imm信号(为1代表alu的b操作数是imm，一般用于i型指令、访存指令地址计算)

    // EXE段信号 前缀:exe_
    wire [WIDTH-1:0] exe_pc4;           // EXE段的pc+4
    wire [WIDTH-1:0] exe_a;             // EXE段的alu操作数a/jr分支目标
    wire [WIDTH-1:0] exe_b;             // EXE段的alu操作数b
    wire [WIDTH-1:0] exe_imm;           // EXE段的imm(一般的imm和shift指令的shamt)
    wire [WIDTH-1:0] exe_alu;           // EXE段得到的alu计算结果
    wire [REGBITS-1:0] exe_rn0;         // EXE段的初始写目标寄存器地址(从流水寄存器得到的id_rn初始值)
    wire [REGBITS-1:0] exe_rn;          // EXE段得到的写目标寄存器地址

    wire exe_wreg;                      // EXE段的寄存器写信号
    wire exe_m2reg;                     // EXE段的存储到寄存器数据传递信号
    wire exe_wmem;                      // EXE段的存储器写信号
    wire exe_jal;                       // EXE段的jal信号(表明当前指令是jal)
    wire [3:0] exe_aluc;                // EXE段的alu操作控制信号 alu control
    wire exe_shift;                     // EXE段的shift信号(为1代表alu的a操作数是shift，一般用于shift类指令)
    wire exe_alu_imm;                   // EXE段的alu_imm信号(为1代表alu的b操作数是imm，一般用于i型指令、访存指令地址计算)

    // MEM段信号 前缀:mem_
    wire [WIDTH-1:0] mem_alu;           // MEM段的alu计算结果
    wire [REGBITS-1:0] mem_rn;          // MEM段的写目标寄存器地址
    wire [WIDTH-1:0] mem_b;             // MEM段的alu操作数b
    wire [WIDTH-1:0] mem_mrd;           // MEM段得到的存储器读数据

    wire mem_wreg;                      // MEM段的寄存器写信号
    wire mem_m2reg;                     // MEM段的存储到寄存器数据传递信号
    wire mem_wmem;                      // MEM段的存储器写信号

    // WB段信号 前缀:wb_
    wire [WIDTH-1:0] wb_mrd;            // WB段的寄存器写信号
    wire [WIDTH-1:0] wb_rwd;            // WB段得到的寄存器写数据
    wire [WIDTH-1:0] wb_alu;            // WB段的alu计算结果
    wire [REGBITS-1:0] wb_rn;           // WB段的写目标寄存器地址

    wire wb_wreg;                       // WB段的寄存器写信号
    wire wb_m2reg;                      // WB段的存储到寄存器数据传递信号

    // pc(program counter)
    pipe_pc#(WIDTH) prog_cnt(clk,clrn,pc_ir_wen,next_pc,pc);
    // IF段
    pipe_if#(WIDTH, ADDR) if_stage(pc_src,pc,b_pc,id_a,j_pc,next_pc,pc4,instr);

    // IF-ID 流水寄存器
    pipe_fd_reg#(WIDTH) fd_reg(clk,clrn,pc_ir_wen,pc4,instr,id_pc4,id_instr);
    // ID段
    pipe_id#(WIDTH, REGBITS) id_stage(clk,clrn,id_pc4,id_instr,
        wb_rwd,exe_alu,mem_alu,mem_mrd,exe_rn,mem_rn,wb_rn,
        exe_wreg,exe_m2reg,mem_wreg,mem_m2reg,wb_wreg,
        id_a,id_b,id_imm,b_pc,j_pc,id_rn,
        pc_src,pc_ir_wen,id_wreg,id_m2reg,id_wmem,id_jal,id_aluc,id_shift,id_alu_imm);

    // ID-EXE 流水寄存器
    pipe_de_reg#(WIDTH, REGBITS) de_reg(clk,clrn,id_a,id_b,id_imm,id_rn,id_pc4,id_aluc,
        id_wreg,id_m2reg,id_wmem,id_shift,id_alu_imm,id_jal,exe_a,exe_b,exe_imm,exe_rn0,
        exe_pc4,exe_aluc,exe_wreg,exe_m2reg,exe_wmem,exe_shift,exe_alu_imm,exe_jal);
    // EXE段
    pipe_exe#(WIDTH, REGBITS) exe_stage(exe_a,exe_b,exe_imm,exe_pc4,exe_rn0,exe_aluc,
        exe_shift,exe_alu_imm,exe_jal,exe_alu,exe_rn);

    // EXE-MEM 流水寄存器
    pipe_em_reg#(WIDTH, REGBITS) em_reg(clk,clrn,exe_alu,exe_b,exe_rn,exe_wreg,exe_m2reg,exe_wmem,
        mem_alu,mem_b,mem_rn,mem_wreg,mem_m2reg,mem_wmem); 
    // MEM段
    pipe_mem#(WIDTH, ADDR) mem_stage(clk,mem_alu,mem_b,mem_wmem,mem_mrd);

    // MEM-WB 流水寄存器
    pipe_mw_reg#(WIDTH, REGBITS) mw_reg(clk,clrn,mem_mrd,mem_alu,mem_rn,mem_wreg,mem_m2reg,
        wb_mrd,wb_alu,wb_rn,wb_wreg,wb_m2reg);
    // WB段
    pipe_wb#(WIDTH, REGBITS) wb_stage(wb_mrd,wb_alu,wb_rn,wb_wreg,wb_m2reg,wb_rwd);
    
endmodule
