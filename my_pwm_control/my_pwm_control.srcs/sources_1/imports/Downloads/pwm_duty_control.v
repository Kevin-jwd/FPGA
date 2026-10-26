`timescale 1ns / 1ps

// 1. 100Mhz --> 10MHz
// 2. 10MHz 주파수를 10% 단위로 해상도 조절
//     ( 0~9까지 총 10단계) 
module pwm_duty_control (
    input clk,
    input reset,
    input [2:0] clean_btn,  // btn[0] =U btn[1]=D btn[2]=C
    output [3:0] duty_cycle,  // FND 출력
    output pwm_out,
    output pwm_out_led,
    output os_out
);

  reg [3:0] r_duty_cycle = 4'd5;  // default 50%
  reg [3:0] r_pwm_counter = 4'd0;
  reg r_prev_duty_inc = 1'b0;
  reg r_prev_duty_dec = 1'b0;
  reg r_prev_stop = 1'b0;

  // 1. btnU btnD rising edge 검출 
  wire w_duty_inc = (clean_btn[0] && !r_prev_duty_inc);  // rising edge 검출
  wire w_duty_dec = (clean_btn[1] && !r_prev_duty_dec);  // rising edge 검출
  wire w_stop = (clean_btn[2] && !r_prev_stop);

  // 2. duty cycle 제어 (btnU btnD)
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      r_duty_cycle <= 4'd5;
      r_prev_duty_inc <= 0;
      r_prev_duty_dec <= 0;
      r_prev_stop <= 0;
    end else begin
      r_prev_duty_inc <= clean_btn[0];  // 버튼 이전 상태 저장 
      r_prev_duty_dec <= clean_btn[1];
      r_prev_stop <= clean_btn[2];
      if (w_stop) r_duty_cycle <= 0;
      if (w_duty_inc && r_duty_cycle < 4'd9) r_duty_cycle <= r_duty_cycle + 1;
      if (w_duty_dec && r_duty_cycle >= 4'd1) r_duty_cycle <= r_duty_cycle - 1;
    end
  end
  // 3. 10MHz PWM 신호 생성(0~9)
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      r_pwm_counter <= 0;
    end else begin
      if (r_pwm_counter >= 4'd9) r_pwm_counter <= 0;
      else r_pwm_counter <= r_pwm_counter + 1;
    end
  end
  assign pwm_out = (r_pwm_counter < r_duty_cycle) ? 1'b1 : 1'b0;
  assign pwm_out_led = pwm_out;
  assign os_out = pwm_out;
  assign duty_cycle = r_duty_cycle;
endmodule
