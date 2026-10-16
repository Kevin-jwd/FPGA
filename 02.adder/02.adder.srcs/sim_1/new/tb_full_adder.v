`timescale 1ns / 1ps

module tb_full_adder ();
  reg i_a, i_b, i_cin;
  wire o_sum, o_cout;

  full_adder u_full_adder (
      .a(i_a),
      .b(i_b),
      .cin(i_cin),
      .sum(o_sum),
      .cout(o_cout)
  );

  initial begin
    #00 i_a = 0;
    i_b   = 0;
    i_cin = 0;
    #10 i_a = 0;
    i_b   = 0;
    i_cin = 1;
    #10 i_a = 0;
    i_b   = 1;
    i_cin = 0;
    #10 i_a = 0;
    i_b   = 1;
    i_cin = 1;
    #10 i_a = 1;
    i_b   = 0;
    i_cin = 0;
    #10 i_a = 1;
    i_b   = 0;
    i_cin = 1;
    #10 i_a = 1;
    i_b   = 1;
    i_cin = 0;
    #10 i_a = 1;
    i_b   = 1;
    i_cin = 1;
    #10 $finish;
  end
endmodule
