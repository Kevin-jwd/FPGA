`timescale 1ns / 1ps
module top_led_fsm (
    input clk,
    input rst,
    input btnU,
    input btnD,
    output [15:0] led
);
  wire clean_btnU, clean_btnD;
  wire press_U, press_D;

  debouncer u_debouncer_U (
      .clk(clk),
      .reset(rst),
      .noisy_btn(btnU),
      .clean_btn(clean_btnU)
  );
  debouncer u_debouncer_D (
      .clk(clk),
      .reset(rst),
      .noisy_btn(btnD),
      .clean_btn(clean_btnD)
  );
  check_btnC u_check_btnU (
      .clk(clk),
      .reset(rst),
      .clean_btnC(clean_btnU),
      .btn_press(press_U)
  );
  check_btnC u_check_btnD (
      .clk(clk),
      .reset(rst),
      .clean_btnC(clean_btnD),
      .btn_press(press_D)
  );
  mealy_machine u_mealy_machine (
      .clk(clk),
      .rst(rst),
      .btn_press(press_U | press_D),
      .data_in(press_U),
      .led(led)
  );
endmodule
