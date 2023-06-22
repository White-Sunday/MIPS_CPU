`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/30 09:39:32
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: CPU设计的主存模块
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory #(parameter WIDTH=32, ADDR=16, CONST_ZERO=32'b0)(
    input clk,
    input mem_write,                        //写信号
    input [ADDR-1:0] addr,
    input [WIDTH-1:0] mem_write_data,       //写入数据
    output reg [WIDTH-1:0] mem_read_data);  //输出数据

    reg [2:0]  mem_en;         //片选
    //根据地址高4位，生成片选信号
    always @(*) begin
        case(addr[ADDR-1:12])
            4'b0000:mem_en=3'b001;
            4'b0001:mem_en=3'b010;
            4'b1111:mem_en=3'b100;
            default:mem_en=3'b000;
        endcase
    end

    //数据
    wire [31:0] ins_rom_out, data_ram_out;  //rom访出数据、ram访出数据

    //rom 32 x 1K (4KB) 地址范围: 0x0000~0x0fff 访存周期: 组合逻辑取数据，无时序
    rom ins_rom (addr[11:2],ins_rom_out);

    //ram 32 x 1K (4KB) 地址范围: 0x1000~0x1fff 访存周期: 一个节拍周期
    ram data_ram (clk,mem_en[1],mem_write,addr[11:2],mem_write_data,data_ram_out);   
    
    //多路选择器根据片选选择输出数据
    always @(*) begin
        case(mem_en)
            3'b001:mem_read_data=ins_rom_out;
            3'b010:mem_read_data=data_ram_out;
            3'b100:mem_read_data=CONST_ZERO;
            3'b000:mem_read_data=CONST_ZERO;
        endcase
    end

endmodule

