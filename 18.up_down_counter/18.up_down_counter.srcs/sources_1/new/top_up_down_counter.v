`timescale 1ns / 1ps

module top_up_down_counter (
    input clk,
    input rst,
    input [2:0] btn,
    input [7:0] sw,
    output [3:0] an,
    output [7:0] seg,
    output [15:0] led
);

  wire w_tick;
  wire [13:0] w_seg_data;
  wire [2:0] w_clean_btn;

  btn_debouncer u_btn_debouncer (
      .clk(clk),
      .rst(rst),
      .noisy_btn(btn),
      .clean_btn(w_clean_btn)
  );

  main_controller u_main_controller (
      .clk(clk),
      .rst(rst),
      .clean_btn(w_clean_btn),
      .sw(sw),
      .seg_data(w_seg_data),
      .led(led)
  );

  tick_generator u_tick_generator (
      .clk (clk),
      .rst (rst),
      .tick(w_tick)
  );

  fnd_controller u_fnd_controller (
      .clk(clk),
      .rst(rst),
      .tick(w_tick),
      .in_data(w_seg_data),
      .an(an),
      .seg(seg)
  );

endmodule
