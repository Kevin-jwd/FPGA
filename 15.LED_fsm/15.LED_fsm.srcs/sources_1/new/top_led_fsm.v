`timescale 1ns / 1ps

module top_led_fsm (
    input clk,
    input rst,
    input btnC,
    output [4:0] led
);

  wire clean_btnC;
  wire btn_press;
  wire w_y;

  debouncer u_debouncer (
      .clk(clk),
      .reset(rst),
      .noisy_btn(btnC),
      .clean_btn(clean_btnC)
  );

  check_btnC u_check_btnC (
      .clk(clk),
      .reset(rst),  // 비동기 reset, active-high
      .clean_btnC(clean_btnC),
      .btn_press(btn_press)
  );

  mealy_machine u_mealy_machine (
      .clk (clk),
      .rst (reset),
      .btnC(btn_press),
      .led (led)
  );

endmodule
