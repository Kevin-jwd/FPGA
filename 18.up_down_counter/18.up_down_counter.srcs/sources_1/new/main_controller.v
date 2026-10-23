`timescale 1ns / 1ps

module main_controller (
    input clk,
    input rst,
    input [2:0] clean_btn,  // 0: L, 1: C, 2: R
    input [7:0] sw,
    output [13:0] seg_data,
    output reg [15:0] led
);

  parameter IDLE = 2'b00;
  parameter UP_COUNTER = 2'b01;
  parameter DOWN_COUNTER = 2'b10;
  parameter SLIDE_SW_READ = 2'b11;

  reg [                  1:0] r_mode = IDLE;

  reg [$clog2(1_000_000)-1:0] r_10ns_cnt = 0;  // 10ns 1_000_000 count
  reg [   $clog2(10_000)-1:0] r_10ms_cnt = 0;  // 10ms 10_000 count

  // 1. check btn mode
  reg                         r_prev_btnL = 0;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      r_mode <= IDLE;
      r_prev_btnL <= 0;
    end else begin
      if (clean_btn[0] && !r_prev_btnL) begin
        r_mode = (r_mode == SLIDE_SW_READ) ? UP_COUNTER : r_mode + 1;
      end
      r_prev_btnL <= clean_btn[0];
    end
  end

  // 2. up/down counter / SLIDE_SW_READ
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      r_10ns_cnt <= 0;
      r_10ms_cnt <= 0;
    end else if (r_mode == UP_COUNTER) begin
      if (r_10ns_cnt == 1_000_000 - 1) begin
        r_10ns_cnt <= 0;
        if (r_10ms_cnt >= 9999) r_10ms_cnt <= 0;
        else r_10ms_cnt <= r_10ms_cnt + 1;
      end else begin
        r_10ns_cnt <= r_10ns_cnt + 1;
      end
      led[13:0] <= r_10ms_cnt;
    end else if (r_mode == DOWN_COUNTER) begin
      if (r_10ns_cnt == 1_000_000 - 1) begin
        r_10ns_cnt <= 0;
        if (r_10ms_cnt == 0) r_10ms_cnt <= 9999;
        else r_10ms_cnt <= r_10ms_cnt - 1;
      end else begin
        r_10ns_cnt <= r_10ns_cnt + 1;
      end
      led[13:0] <= r_10ms_cnt;
    end else begin
      led[13:8] <= 6'b000_000;
      led[7:0]  <= sw[7:0];
    end
  end

  // 3. display mode
  always @(r_mode) begin
    case (r_mode)
      UP_COUNTER: begin
        led[15:14] = UP_COUNTER;
      end
      DOWN_COUNTER: begin
        led[15:14] = DOWN_COUNTER;
      end
      SLIDE_SW_READ: begin
        led[15:14] = SLIDE_SW_READ;
      end
      default: begin
        led[15:14] = IDLE;
      end
    endcase

  end

  assign seg_data = (r_mode == UP_COUNTER) ? r_10ms_cnt:
                      (r_mode == DOWN_COUNTER) ? r_10ms_cnt: sw;

endmodule
