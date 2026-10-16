`timescale 1ns / 1ps

module top_button_debounce (
    input  btnC,
    input  clk,
    input  rst,
    output led,
    output led1
);

  button_debounce u_button_debounce (
      .btnC(btnC),
      .clk(clk),
      .rst(rst),
      .clean_btn(clean_btn),
      .led1(led1)
  );

  led_toggle u_led_toggle (
      .clean_btn(clean_btn),
      .led(led)
  );

endmodule
