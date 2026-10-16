`timescale 1ns / 1ps

module button_debounce (
    input  btnC,
    input  clk,
    input  rst,
    output clean_btn,
    output led1
);

  wire q1;
  wire q2;

  wire w_oclk;
  wire w_tick;

  clock_80Hz u_clock_80Hz (
      .clk  (clk),
      .rst  (rst),
      .o_clk(w_oclk)
  );

  D_FF u_D_FF1 (
      .o_clk(w_oclk),
      .rst(rst),
      .d(btnC),
      .q(q1)
  );

  D_FF u_D_FF2 (
      .o_clk(w_oclk),
      .rst(rst),
      .d(q1),
      .q(q2)
  );

  tick_generator u_tick_generator (
      .clk (clk),
      .rst (rst),
      .tick(w_tick)
  );

  led_on_off_500ms u_led_on_off_500ms (
      .tick(w_tick),
      .led1(led1)
  );

  assign clean_btn = q1 & ~q2;

endmodule
