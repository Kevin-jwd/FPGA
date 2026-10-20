`timescale 1ns / 1ps

module button_debounce (
    input  btn,
    input  clk,
    input  rst,
    output clean_btn
);

  wire q1;
  wire q2;

  wire w_oclk;

  clock_80Hz u_clock_80Hz (
      .clk  (clk),
      .rst  (rst),
      .o_clk(w_oclk)
  );

  D_FF u_D_FF1 (
      .o_clk(w_oclk),
      .rst(rst),
      .d(btn),
      .q(q1)
  );

  D_FF u_D_FF2 (
      .o_clk(w_oclk),
      .rst(rst),
      .d(q1),
      .q(q2)
  );

  assign clean_btn = q1 & ~q2;

endmodule
