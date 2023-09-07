`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: coprocessor1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: fdiv newton
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module newton24 (a,b,fdiv,ena,clk,clrn,q,busy,count,reg_x,stall);
    input [23:0] a;         // dividend: .1xxx...x
    input [23:0] b;         // divisor:  .1xxx...x
    input fdiv;             // ID stage: i_fdiv
    input clk,clrn;         // clock and reset
    input ena;              // enable
    output [31:0] q;        // quotient: x.xxx...x
    output reg busy;
    output [4:0] count;     // counter
    output [25:0] reg_x;    // for sim test only 01.xxx...x
    output stall;           // for pipeline stall
    
    reg [31:0] q;           // 32-bit: x.xxx...x
    reg [25:0] reg_x;       // 26-bit: xx.xxx...x
    reg [23:0] reg_a;       // 24-bit: .1xxx...x
    reg [23:0] reg_b;       // 24-bit: .1xxx...x
    reg [4:0] count;        // 3 iterations * 5 cycles
    
    wire [49:0] bxi;        // xx.xxx...x
    wire [51:0] x52;        // xxx.xxx...x
    wire [49:0] d_x;        // 0x.xxx...x
    wire [31:0] e2p;        // sticky
    wire [7:0] x0 = rom(b[22:19]);  // x0: from rom table
    
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            busy <= 0;
            count <= 0;
            reg_x <= 0;
        end else begin
            if (fdiv & (count == 0)) begin
                count <= 5'b1;
                busy <= 1'b1;
            end else begin
                if (count == 5'h01) begin                   // 1 x0
                    reg_a <= a;
                    reg_b <= b;
                    reg_x <= {2'b1,x0,16'b0};   // .1xxx...x (b) -> 01.xxxxxxxx000...0 (reg_x)
                end
                if (count != 0) count <= count + 5'b1;      // count += 1
                if (count == 5'h0f) busy <= 0;              // ready for next
                if (count == 5'h10) count <= 5'b0;          // reset count to 0
                if ((count == 5'h06) ||                     // 2 3 4 5 6 save result of 1st iteration
                    (count == 5'h0b) ||                     // 7 8 9 10 11 save result of 2nd iteration
                    (count == 5'h10))                       // 12 13 14 15 16 no need to save here actually
                    reg_x <= x52[50:25];		    // xx.xxx...x
            end
        end
    end

    assign stall = fdiv & (count == 0) | busy;
    
    // wallace_26x24
    wallace_26x24_product bxxi(reg_x, reg_b, bxi);      // xi*b 01.xxx...0*.1xxx...x=0x.xxx...x (0.5<xi*b<2.0)
    wire [25:0] b26 = ~bxi[48:23] + {25'b0, 1'b1};      // 2-xi*b 10.000...0-x.x...x=x.xxx...x (b26<2.0)
    wallace_26x26_product xip1(reg_x, b26, x52);        // xi*(2-xi*b) 01.xxx...0*x.xxx...x=00x.xxx...x (<2.0)
    
    reg [25:0] reg_de_x;        // pipline register in between id and e1,x
    reg [23:0] reg_de_a;        // pipline register in between id and e1,a
    wire [49:0] m_s;            // sum
    wire [49:8] m_c;            // carry
    // wallace_24x26
    wallace_24x26 wt(reg_de_a, reg_de_x, m_s[49:8],m_c,m_s[7:0]);   // a*xn 
    reg [49:0] a_s;             // pipeline register in between e1 and e2,sum
    reg [49:8] a_c;             // pipeline register in between e1 and e2,carry
    assign d_x = a_s + {a_c,8'b0};	// 0x.xxx...x (<2.0)
    assign e2p = {d_x[48:18],|d_x[17:0]};           // sticky bit

    always @ (negedge clrn or posedge clk) begin
        if (!clrn) begin
            reg_de_x <= 0;      // id-e1
            reg_de_a <= 0;
            a_s <= 0;           // e1-e2
            a_c <= 0;
            q <= 0;             // e2-e3
        end else if (ena) begin
            reg_de_x <= x52[50:25];     // id-e1
            reg_de_a <= reg_a;
            a_s <= m_s;                 // e1-e2
            a_c <= m_c;
            q <= e2p;                   // e2-e3
        end
    end

    function [7:0] rom;     // a rom table y = 1 / x (estimate)
        input [3:0] b;
        case (b)
            4'h0: rom = 8'hff;  // 1 / .10000xxx...x approximately equal to 01.11111111000...0     
            4'h1: rom = 8'hdf;
            4'h2: rom = 8'hc3;      
            4'h3: rom = 8'haa;
            4'h4: rom = 8'h93;      
            4'h5: rom = 8'h7f;
            4'h6: rom = 8'h6d;      
            4'h7: rom = 8'h5c;
            4'h8: rom = 8'h4d;      
            4'h9: rom = 8'h3f;
            4'ha: rom = 8'h33;      
            4'hb: rom = 8'h27;
            4'hc: rom = 8'h1c;      
            4'hd: rom = 8'h12;
            4'he: rom = 8'h08;      
            4'hf: rom = 8'h00;  // 1 / .11111xxx...x approximately equal to 01.000...0   
        endcase
    endfunction
endmodule
