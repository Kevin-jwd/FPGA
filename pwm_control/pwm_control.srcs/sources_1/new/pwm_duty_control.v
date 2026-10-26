`timescale 1ns / 1ps

// 1. 100MHz -> 10MHz 
// 2. control resolution of 10MHz frequency in unit 10% (0~9, total 10 steps)
module pwm_duty_control (
    input        clk,
    input        rst,
    input  [2:0] clean_btn,
    output [3:0] duty_cycle,  // FND 출력
    output       pwm_out,
    output       pwm_out_led
);

  reg [3:0] r_duty_cycle = 4'd5;  // default: 50%
  reg [3:0] r_pwm_counter = 4'd0;
  reg r_prev_duty_inc, r_prev_duty_dec;

  // 0. detect btnU btnD rising edge
  wire w_duty_inc = (clean_btn[0] && !r_prev_duty_inc);
  wire w_duty_dec = (clean_btn[0] && !r_prev_duty_dec);

  // 1. control duty cycle (btnU, btnD)
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      r_duty_cycle = 4'd5;
      r_prev_duty_inc <= 0;
      r_prev_duty_dec <= 0;
    end else begin
      r_prev_duty_inc <= clean_btn[0];
      r_prev_duty_dec <= clean_btn[1];
      if (w_duty_inc && r_duty_cycle < 4'd9) r_duty_cycle <= r_duty_cycle + 1;
      if (w_duty_dec && r_duty_cycle >= 4'd1) r_duty_cycle <= r_duty_cycle - 1;
    end
  end

  // 2. generate 10MHz PWM signal (0~9)
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      r_pwm_counter <= 0;
    end else begin
      if (r_pwm_counter >= 4'd9) r_pwm_counter <= 0;
      else r_pwm_counter <= r_pwm_counter + 1;
    end
  end

  assign pwm_out = (r_pwm_counter < r_duty_cycle) ? 1'b1 : 1'b0;
  assign pwm_out_led = pwm_out;

endmodule
