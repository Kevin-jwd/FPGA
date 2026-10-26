`timescale 1ns / 1ps
module top (
    input clk,
    input reset,
    input [2:0] btn,
    input [1:0] sw,
    output [7:0] seg,
    output [3:0] an,
    output pwm_out,
    output pwm_out_led,
    output [1:0] in1_in2,
    output os_out
);

  wire [2:0] w_clean_btn;
  wire w_tick;
  wire [3:0] w_duty_cycle;

  btn_debouncer u_btn_debouncer (
      .clk(clk),
      .reset(reset),
      .noisy_btn(btn),  // raw noisy button input
      .clean_btn(w_clean_btn)
  );

  pwm_duty_control u_pwm_duty_control (
      .clk(clk),
      .reset(reset),
      .clean_btn(w_clean_btn),
      .duty_cycle(w_duty_cycle),  // FND에 duty 출력 표시 0~9
      .pwm_out(pwm_out),
      .pwm_out_led(pwm_out_led),
      .os_out(os_out)
  );

  tick_generator u_tick_generator (
      .clk  (clk),
      .reset(reset),
      .tick (w_tick)
  );

  fnd_controller u_fnd_controller (
      .clk(clk),
      .reset(reset),
      .tick(w_tick),
      .in_data({10'b0, w_duty_cycle}),
      .motor_direction(sw),
      .an(an),
      .seg(seg)
  );

  assign in1_in2 = sw;
endmodule
