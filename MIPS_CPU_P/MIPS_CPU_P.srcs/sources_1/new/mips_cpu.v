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


module mips_cpu #(parameter WIDTH=32, ADDR=16, REGBITS=5)(
    input clk,                          // 时钟
    input clrn,                         // 复位信号
    output [WIDTH-1:0] pc,
    output [WIDTH-1:0] id_instr,        // ID段的指令
    output [WIDTH-1:0] exe_alu,         // EXE段的alu计算结果
    output [WIDTH-1:0] mem_alu,         // MEM段的alu计算结果
    output [WIDTH-1:0] wb_rwd);         // 写入寄存器数据(reg write data)

    // 针对五段之间传递的信号(即用于流水寄存器的信号)作了前缀处理以相互区分
    // IF段信号 前缀:无
    wire [WIDTH-1:0] pc4;               // IF段得到的pc+4
    wire [WIDTH-1:0] instr;             // IF段得到的instr
    wire [WIDTH-1:0] next_pc;

    // ID段信号 前缀:id_
    wire [WIDTH-1:0] id_pc4;            // ID段的pc+4
    wire [WIDTH-1:0] id_instr;          // ID段的instr
    wire [WIDTH-1:0] id_a;              // ID段得到的alu操作数a/jr分支目标
    wire [WIDTH-1:0] id_b;              // ID段得到的alu操作数b
    wire [WIDTH-1:0] id_imm;            // ID段得到的imm(一般的imm和shift指令的shamt)
    wire [WIDTH-1:0] b_pc;              // 条件分支目标branch_pc(beq,bne)
    wire [WIDTH-1:0] j_pc;              // 无条件分支目标jump_pc(j,jal)
    wire [REGBITS-1:0] id_rn;           // ID段得到的写目标寄存器地址

    wire [1:0] pc_src;                  // next pc选择信号
    wire pc_wen;                        // pc写使能信号
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

    wire wb_wreg;                       // MEM段的寄存器写信号
    wire wb_m2reg;                      // MEM段的存储到寄存器数据传递信号

    // pc(program counter)
    pipe_pc prog_cnt(next_pc,pc_wen,clk,clrn,pc);
    // IF段
    pipe_if if_stage(pc_src,pc,b_pc,id_a,j_pc,next_pc,pc4,instr);

    // IF-ID 流水寄存器
    pipe_fd_reg fd_reg(pc4,instr,pc_wen,clk,clrn,id_pc4,id_instr);
    // ID段
    pipe_id id_stage();

    // ID-EXE 流水寄存器
    pipe_de_reg de_reg();
    // EXE段
    pipe_exe exe_stage();

    // EXE-MEM 流水寄存器
    pipe_em_reg em_reg(); 
    // MEM段
    pipe_mem mem_stage();

    // MEM-WB 流水寄存器
    pipe_mw_reg wm_reg();
    // WB段
    pipe_wb wb_stage();
    
endmodule
