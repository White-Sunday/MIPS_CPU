`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: shift
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


module shift #(parameter WIDTH=32)(
    input [WIDTH-1:0] d,            // input data
    input [4:0] sa,                 // shift amount
    input right,                    // 1:shift right 0:shift left
    input arith,                    // 1:arithmetic mode 0:logic mode
    output reg [WIDTH-1:0] sh);     // shifted result

    always @(*) begin
        if (!right) begin
            sh = d << sa;           // 左移(算术,逻辑左移都是一样的)
        end else begin
            if (arith) begin
                // $signed(c)是一个function，将无符号数c转化为有符号数返回，不改变c的类型和内容
                // 不加$signed >>> 就没用
                sh = $signed (d) >>> sa;    // 算术右移
            end else begin
                sh = d >> sa;               // 逻辑右移
            end
        end
    end
    
endmodule
