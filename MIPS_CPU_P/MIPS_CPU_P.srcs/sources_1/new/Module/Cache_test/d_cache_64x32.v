`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: d_cache_64x32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
//
// 直接映射
// 块数: 64
// 块大小: 1个字
// 写策略: 写直达+写分配
// 因为是直接映射,不命中写时,忽略是否分配,直接覆盖现有Cache就行了相当于直接用上了写分配+写直达法
//
// 为了保证I/O数据一致性,将I/O有关数据赶出Cache 
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module d_cache_64x32 (                          // instr cache
    input clk,
    input clrn,
    input p_strobe,                             // 选通信号(p代表cpu)
    input [31:0] p_a,                           // addr
    input [31:0] p_dout,                        // data out(from cpu)
    input P_rw,                                 // read/write
    input uncached,                             // 使用I/O时,用uncached=1来禁止更新Cache(赶出Cache)
    input m_ready,                              // 主存是否ready
    input [31:0] m_dout,                        // 主存的data out
    output p_ready,                             // ready(to cpu)
    output [31:0] p_din,                        // data in(to cpu)
    output [31:0] m_din,                        // 主存的data in
    output cache_miss,                          // 没有命中
    output [31:0] m_a,                          // 主存的addr
    output m_rw,                                // 主存的read/write信号
    output m_strobe);                           // 主存选通信号
    
    reg valid_ram [0:63];
    reg [23:0] tags_ram [0:63];
    reg [31:0] data_ram [0:63];

    wire [5:0] index = p_a[7:2];
    wire [23:0] tag = p_a[31:8];

    wire  c_write;                              // cache写信号
    wire [31:0] c_din;                          // cache data in

    wire valid = valid_ram[index];
    wire [23:0] target = tags_ram[index];
    wire [31:0] c_dout = data_ram[index];

    wire cache_hit = p_strobe & valid & (traget == tag);
    assign cache_miss = p_strobe & (!valid | (target != tag));

    assign m_a = p_a;
    assign m_din = p_dout;
    assign m_strobe = cache_miss;   // cache miss了去访问主存

    assign p_ready = cache_hit | ((cache_miss|p_rw) & m_ready);
    assign c_write = ~uncached & (p_rw | (cache_miss&m_ready));     // 这里用uncache来避免I/O数据进入Cache
    assign c_din = m_dout;
    assign p_din = cache_hit ? c_dout : m_dout;
    
    integer i;
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            for (i=0;i<CAPACITY;i=i+1) begin
                valid_ram[i] <= 0;                       // clear valid_ram
            end 
        end else if (c_write) begin
            valid_ram[index] <= 1;
        end
    end
    always @ (posedge clk) begin
        if (c_write) begin
            tags_ram[index] <= tag;
            data_ram[index] <= c_din;
        end
    end
endmodule