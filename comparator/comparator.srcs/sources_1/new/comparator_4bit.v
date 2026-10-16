`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/15 09:45:00
// Design Name: 
// Module Name: comparator_4bit
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


module comparator_4bit (
    input      [3:0] a,
    input      [3:0] b,
    output reg       eq,  // Equal
    output reg       gt,  // Greater Than
    output reg       lt   // Less Than
);

  always @(*) begin
    // 기본 값 설정
    eq = 0;
    gt = 0;
    lt = 0;

    if (a > b) begin
      gt = 1;
    end else if (a < b) begin
      lt = 1;
    end else begin
      eq = 1;
    end

  end
endmodule
