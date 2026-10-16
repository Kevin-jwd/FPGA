`timescale 1ns / 1ps

module top_up_counter (
    input clk,
    input rst,
    input btnU,
    input btnD,
    output [15:0] led
);

  wire w_tick;
  wire [1:0] w_clean_btn;

  tick_generator u_tick_generator (
      .clk (clk),
      .rst (rst),
      .tick(w_tick)
  );

  btn_debounce u_btn_debounce (
      .clk(w_tick),
      .rst(rst),
      .btnU(btnU),
      .btnD(btnD),
      .clean_btn(w_clean_btn)
  );

  up_counter u_up_counter (
      .clk(w_tick),
      .rst(rst),
      .clean_btn(w_clean_btn),
      .led(led)
  );

endmodule
