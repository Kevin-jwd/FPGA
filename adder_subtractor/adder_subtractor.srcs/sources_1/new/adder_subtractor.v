`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/15 09:37:47
// Design Name: 
// Module Name: adder_subtractor
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


module adder_subtractor (
    input [3:0] a,
    input [3:0] b,
    input sel,
    output [3:0] result,
    output out
);

    assign {out, result} = sel ? a[3:0] + b[3:0] : {1'b0 , a} + {1'b0, -b[3:0]} + 4'd1;
endmodule
