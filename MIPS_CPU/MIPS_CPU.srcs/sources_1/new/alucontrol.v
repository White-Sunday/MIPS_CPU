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
    input [3:0] alu_op,
    input [5:0] funct,
    output reg [3:0] alu_cont);

    always @(*)
        case(alu_op)
            4'b0000: alu_cont = 4'b0000;  //add for lw/sw/addi/addiu/lui/jal
            4'b0001: alu_cont = 4'b0001;  //sub for beq
            4'b0010: alu_cont = 4'b0010;  //and for andi
            4'b0011: alu_cont = 4'b0011;  //or for ori
            4'b0100: alu_cont = 4'b0100;  //xor for xori
            4'b0101: alu_cont = 4'b0101;  //(a==b)?1:0 for bne
            4'b0110: alu_cont = 4'b1000;  //(a>b)?1:0 for bgtz
            4'b0111: alu_cont = 4'b0110;  //(a<b)?1:0 for slti,bltz
            4'b1000: alu_cont = 4'b0111;  //(a<b)?1:0 (u) for sltiu
            default:
                case(funct)
                    6'b100000: alu_cont = 4'b0000;  //add for add
                    6'b100010: alu_cont = 4'b0001;  //sub for sub
                    6'b000000: alu_cont = 4'b1001;  //sll for sll
                    6'b000010: alu_cont = 4'b1010;  //srl for srl
                    6'b101010: alu_cont = 4'b0110;  //(a<b)?1:0 for slt
                    6'b100001: alu_cont = 4'b0000;  //add for addu
                    6'b100100: alu_cont = 4'b0010;  //and for and
                    6'b001000: alu_cont = 4'b0000;  //add for jr
                default:
                    alu_cont = 4'b1111;
                endcase
        endcase
endmodule
