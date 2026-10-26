`timescale 1ns / 1ps

module top_pwm_control (
    input clk,
    input rst,
    input [2:0] btn,
    input [1:0] sw,
    output [1:0] in,
    output pwm_out,
    output pwm_out_led,
    output [3:0] an,
    output [7:0] seg,
    output [3:0] JA         // JA1: ENA, JA2: in1, JA3: in2 JA4: Osciloscope output
);

  wire [2:0] w_clean_btn;
  wire w_tick;
  wire [3:0] w_duty_cycle;

  btn_debouncer u_btn_debouncer (
      .clk(clk),
      .rst(rst),
      .noisy_btn(btn),
      .clean_btn(w_clean_btn)
  );

  tick_generator u_tick_generator (
      .clk (clk),
      .rst (rst),
      .tick(w_tick)
  );

  pwm_duty_control u_pwm_duty_control (
    .clk(clk),
    .rst(rst),
    .clean_btn(w_clean_btn),
    .duty_cycle(w_duty_cycle),
    .pwm_out(pwm_out),
    .pwm_out_led(pwm_out_led)
  );

  fnd_controller u_fnd_controller (
      .clk(clk),
      .rst(rst),
      .tick(w_tick),
      .in_data({10'b0, w_duty_cycle}),
      .motor_dir(sw),
      .an(an),
      .seg(seg)
  );

  assign in = sw;

endmodule
