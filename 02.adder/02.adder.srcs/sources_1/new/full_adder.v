`timescale 1ns / 1ps

module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

  wire w_sum1, w_cout1, w_cout2;

  half_adder u1_half_adder (
      .a(a),
      .b(b),
      .sum(w_sum1),
      .cout(w_cout1)
  );

  half_adder u2_half_adder (
      .a(w_sum1),
      .b(cin),
      .sum(sum),
      .cout(w_cout2)
  );

  assign cout = w_cout1 | w_cout2;
endmodule
