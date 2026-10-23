`timescale 1ns / 1ps

module top_stopwatch (
    input clk,
    input rst,
    input [3:0] btn,  // btnL, btnR, btnU, btnD
    input [7:0] sw,
    output [3:0] an,
    output [7:0] seg,
    output [15:0] led
);

  wire [3:0] w_clean_btn;
  wire w_tick;
  wire [13:0] w_seg_data;

  btn_debouncer u_btn_debouncer (
      .clk(clk),
      .rst(rst),
      .btn(btn),
      .clean_btn(w_clean_btn)
  );

  tick_generator u_tick_generator (
      .clk (clk),
      .rst (rst),
      .tick(w_tick)
  );

  main_controller u_main_controller (
      .tick(w_tick),
      .rst(rst),
      .clean_btn(w_clean_btn),
      .sw(sw),
      .seg_data(w_seg_data),
      .led(led)
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
