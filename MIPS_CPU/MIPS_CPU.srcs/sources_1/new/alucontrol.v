`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/01 14:59:33
// Design Name: 
// Module Name: alu_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 运算器控制
// 根据alu_op信号和函数码控制alu进行何种运算 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alucontrol(
    input [2:0] alu_op,
    input [5:0] funct,
    output reg [3:0] alu_cont);

    always @(*)
        case(alu_op)
            3'b000: alu_cont = 4'b0000;  //add for lw/sw/addi/jal
            3'b001: alu_cont = 4'b0001;  //andi
            3'b010: alu_cont = 4'b0010;  //beq
            3'b011: alu_cont = 4'b0011;  //bne
            3'b100: alu_cont = 4'b0100;  //bgtz
            3'b101: alu_cont = 4'b0101;  //lui
            3'b110: alu_cont = 4'b0110;  //ori
            default:
                case(funct)
                    6'b100000: alu_cont = 4'b0000;  //add 这里addu跟add用了一样的操作，没有进行溢出判断
                    6'b100010: alu_cont = 4'b0010;  //sub
                    6'b000000: alu_cont = 4'b0111;  //sll
                    6'b000010: alu_cont = 4'b1000;  //srl
                    6'b101010: alu_cont = 4'b1001;  //slt
                    6'b100001: alu_cont = 4'b0000;  //addu
                    6'b100100: alu_cont = 4'b0001;  //and
                    6'b001000: alu_cont = 4'b0000;  //jr
                default:
                    alu_cont = 4'b1111;
                endcase
        endcase
endmodule
