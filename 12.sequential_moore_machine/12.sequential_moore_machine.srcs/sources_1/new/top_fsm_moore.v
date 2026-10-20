`timescale 1ns / 1ps

module top_fsm_moore (
    input  clk,
    input  rst,
    input  x_in,
    output y_out
);

  wire w_y_out;

  my_fsm_moore u_fsm_moore (
      .clk  (clk),
      .rst  (rst),
      .x_in (x_in),
      .y_out(w_y_out)
  );

  debouncer u_debouncer (
      .clk(clk),
      .reset(rst),
      .noisy_btn(x_in),
      .clean_btn()
  );

  assign y_out = w_y_out;

endmodule
