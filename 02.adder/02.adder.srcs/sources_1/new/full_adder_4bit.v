`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/07 15:17:51
// Design Name: 
// Module Name: full_adder_4bit
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


module full_adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

  wire w_carry0, w_carry1, w_carry2;
  full_adder FA0 (
      .a(a[0]),  // a[0] 1bit
      .b(b[0]),
      .cin(1'b0),
      .sum(sum[0]),
      .cout(w_carry0)
  );  // named instantiation

  full_adder FA1 (
      .a(a[1]),  // a[0] 1bit
      .b(b[1]),
      .cin(w_carry0),
      .sum(sum[1]),
      .cout(w_carry1)
  );
  full_adder FA2 (
      .a(a[2]),  // a[0] 1bit
      .b(b[2]),
      .cin(w_carry1),
      .sum(sum[2]),
      .cout(w_carry2)
  );
  full_adder FA3 (
      .a(a[3]),  // a[0] 1bit
      .b(b[3]),
      .cin(w_carry2),
      .sum(sum[3]),
      .cout(cout)
  );

endmodule
