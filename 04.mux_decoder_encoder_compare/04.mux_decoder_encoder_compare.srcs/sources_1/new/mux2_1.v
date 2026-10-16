`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/14 11:26:42
// Design Name: 
// Module Name: mux2_1
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


module mux2_1 (
    input a,
    input b,
    input sel,
    output reg out
);

  always @(sel, a, b) begin
    case (sel)
      1'b1: out = a;
      1'b0: out = b;
      default: out = 1'bx;
    endcase
  end
endmodule
