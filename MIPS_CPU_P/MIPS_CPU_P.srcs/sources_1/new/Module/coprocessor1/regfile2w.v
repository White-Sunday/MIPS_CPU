`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 23:30:31
// Design Name: 
// Module Name: regfile2w
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

module regfile2w #(parameter WIDTH=32, REGBITS=5)(
    input clk,
    input clrn,
    input [WIDTH-1:0] dx,       // write data
    input [WIDTH-1:0] dy,
    input [REGBITS-1:0] rna,    // reg read number
    input [REGBITS-1:0] rnb,
    input [REGBITS-1:0] wnx,    // reg write number
    input [REGBITS-1:0] wny,
    input wex,                  // write enable
    input wey,
    output [WIDTH-1:0] qa,      // read data
    output [WIDTH-1:0] qb);

    reg [31:0] register [0:31];
    assign qa = register[rna];
    assign qb = register[rnb];
    integer i;
    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin
            for (i=0; i<32; i=i+1) 
                register[i] <= 0;
        end else begin
            if (wey) begin      // port y 的优先级比 port x 高
                register[wny] <= dy;
            end
            if (wex && (!wey || (wnx != wny))) begin
                register[wnx] <= dx;
            end
        end
    end
endmodule
