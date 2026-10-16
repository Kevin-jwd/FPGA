`timescale 1ns / 1ps

module top_btn (
    input clk,
    input rst,
    input sel,
    input btnU,
    input btnD,
    output [1:0] led,
    output clean_btn
);

  wire w_btn;
  wire w_tick;

  tick_generator u_tick_generator (
      .clk (clk),
      .rst (rst),
      .tick(w_tick)
  );

  btn_debounce u_btn_debounce (
      .clk(w_tick),
      .btn(w_btn),
      .rst(rst),
      .clean_btn(clean_btn)
  );
  led_toggle u_led_toggle (
      .btn (clean_btn),
      .rst (rst),
      .led2(led[1])
  );

  mux u_mux (
      .btnU(btnU),
      .btnD(btnD),
      .sel (sel),
      .btn (w_btn)
  );

  assign led[0] = clean_btn;

endmodule
