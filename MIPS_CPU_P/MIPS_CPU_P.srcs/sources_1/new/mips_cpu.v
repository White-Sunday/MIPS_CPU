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
    input intr,                         // 中断请求信号(interrupt request)
    output [WIDTH-1:0] pc,
    output [WIDTH-1:0] id_instr,        // ID段的指令
    output [WIDTH-1:0] exe_alu,         // EXE段得到的alu计算结果
    output [WIDTH-1:0] mem_alu,         // MEM段的alu计算结果
    output [WIDTH-1:0] wb_rwd,          // WB段得到的写入寄存器数据(reg write data)
    output inta);                       // 中断响应信号(interrupt aknowledgement)

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
    wire ov;                            // EXE段的alu计算(ADD,SUB)结果是否溢出

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

    // pc(program counter) ei_next_pc涉及异常/中断处理,原为next_pc
    pipe_pc#(WIDTH) prog_cnt(clk,clrn,pc_ir_wen,ei_next_pc,pc);
    // IF段 ei_pc_src涉及异常/中断处理,原为pc_src
    pipe_if#(WIDTH, ADDR) if_stage(ei_pc_src,pc,b_pc,id_a,j_pc,next_pc,pc4,instr);

    // IF-ID 流水寄存器
    pipe_fd_reg#(WIDTH) fd_reg(clk,clrn,pc_ir_wen,pc4,instr,id_pc4,id_instr);
    // ID段  exe_ei_alu涉及异常/中断处理,原为exe_alu
    pipe_id#(WIDTH, REGBITS) id_stage(clk,clrn,id_pc4,id_instr,
        wb_rwd,exe_ei_alu,mem_alu,mem_mrd,exe_rn,mem_rn,wb_rn,
        exe_wreg,exe_m2reg,mem_wreg,mem_m2reg,wb_wreg,
        id_a,id_b,id_imm,b_pc,j_pc,id_rn,
        pc_src,pc_ir_wen,id_wreg,id_m2reg,id_wmem,id_jal,id_aluc,id_shift,id_alu_imm);

    // ID-EXE 流水寄存器 id_ei_wreg,id_ei_wmem涉及异常/中断处理,原为id_wreg,id_wmem
    pipe_de_reg#(WIDTH, REGBITS) de_reg(clk,clrn,id_a,id_b,id_imm,id_rn,id_pc4,id_aluc,
        id_ei_wreg,id_m2reg,id_ei_wmem,id_shift,id_alu_imm,id_jal,exe_a,exe_b,exe_imm,exe_rn0,
        exe_pc4,exe_aluc,exe_wreg,exe_m2reg,exe_wmem,exe_shift,exe_alu_imm,exe_jal);
    // EXE段
    pipe_exe#(WIDTH, REGBITS) exe_stage(exe_a,exe_b,exe_imm,exe_pc4,exe_rn0,exe_aluc,
        exe_shift,exe_alu_imm,exe_jal,exe_alu,exe_rn,ov);

    // EXE-MEM 流水寄存器 exe_ei_alu涉及异常/中断处理,原为exe_alu
    pipe_em_reg#(WIDTH, REGBITS) em_reg(clk,clrn,exe_ei_alu,exe_b,exe_rn,exe_wreg,exe_m2reg,exe_wmem,
        mem_alu,mem_b,mem_rn,mem_wreg,mem_m2reg,mem_wmem);
    // MEM段
    pipe_mem#(WIDTH, ADDR) mem_stage(clk,mem_alu,mem_b,mem_wmem,mem_mrd);

    // MEM-WB 流水寄存器
    pipe_mw_reg#(WIDTH, REGBITS) mw_reg(clk,clrn,mem_mrd,mem_alu,mem_rn,mem_wreg,mem_m2reg,
        wb_mrd,wb_alu,wb_rn,wb_wreg,wb_m2reg);
    // WB段
    pipe_wb#(WIDTH, REGBITS) wb_stage(wb_mrd,wb_alu,wb_rn,wb_wreg,wb_m2reg,wb_rwd);
    
    // 中断/异常处理
    // IF段信号 pc,intr
    // ID段信号
    wire [WIDTH-1:0] id_pc;              // ID段的pc
    wire id_intr;                        // ID段的intr
    wire [WIDTH-1:0] ei_next_pc;        // 考虑异常/中断后的next_npc
    wire id_ei_wreg;                    // 经过cp0的处理,可以取消当前指令的执行
    wire id_ei_wmem;                    // 经过cp0的处理,可以取消当前指令的执行
    wire id_is_bj;
    wire id_ov_en;
    wire id_cancel;
    wire [WIDTH-1:0] id_cau;            // cause寄存器的内容
    wire [WIDTH-1:0] id_sta;            // status寄存器的内容 IM[3:0]:ov,unimpl,sys,int;在程序里设置其初值,并限制嵌套次数
    wire [WIDTH-1:0] id_epc;            // epc寄存器的内容
    wire [1:0] ei_pc_src;               // 经过cp0的处理,可以取消BJ指令的执行
    wire [1:0] id_mfc0;                 // move from cp0指令用于选择exe段的pc8,sta,cau与epc做为exe_alu
    // EXE段信号
    reg [WIDTH-1:0] exe_cau;
    reg [WIDTH-1:0] exe_sta;
    reg [WIDTH-1:0] exe_epc;
    reg [WIDTH-1:0] exe_pc;
    reg exe_is_bj;
    reg exe_ov_en;
    reg exe_cancel;
    reg [1:0] exe_mfc0;
    wire exe_ovr;
    wire [WIDTH-1:0] exe_ei_alu;
    // MEM段信号
    reg [WIDTH-1:0] mem_pc;
    reg mem_is_bj;
    reg mem_ovr;
    // PC(无)
    // IF段(无)
    // FD流水寄存器
    dffe32 fd_pc(pc,clk,clrn,pc_ir_wen,id_pc);
    dff fd_intr(intr,clk,clrn,id_intr);
    // ID段
    coprocessor0#(WIDTH) cp0(clk,clrn,id_intr,id_instr,next_pc,pc,id_pc,exe_pc,
        mem_pc,id_b,pc_src,exe_is_bj,mem_is_bj,exe_cancel,exe_ovr,mem_ovr,id_wreg,
        id_wmem,ei_next_pc,id_ei_wreg,id_ei_wmem,id_is_bj,id_ov_en,id_cancel,
        id_cau,id_sta,id_epc,id_mfc0,ei_pc_src,inta);
    
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
