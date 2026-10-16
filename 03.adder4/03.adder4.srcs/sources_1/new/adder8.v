`timescale 1ns / 1ps

module adder8 (
    input [6:0] a,
    input [6:0] b,
    input cin,  // 1bit
    output [6:0] sum,
    output cout
);

  wire w_carry0, w_carry1, w_carry2, w_carry3, w_carry4, w_carry5;

  full_adder FA0 (
      .a(a[0]),  // a[0] 1bit
      .b(b[0]),
      .cin(cin),
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
      .cout(w_carry3)
  );
  full_adder FA4 (
      .a(a[4]),  // a[0] 1bit
      .b(b[4]),
      .cin(w_carry3),
      .sum(sum[4]),
      .cout(w_carry4)
  );  // named instantiation

  full_adder FA5 (
      .a(a[5]),  // a[0] 1bit
      .b(b[5]),
      .cin(w_carry4),
      .sum(sum[5]),
      .cout(w_carry5)
  );
  full_adder FA6 (
      .a(a[6]),  // a[0] 1bit
      .b(b[6]),
      .cin(w_carry5),
      .sum(sum[6]),
      .cout(cout)
  );

endmodule
