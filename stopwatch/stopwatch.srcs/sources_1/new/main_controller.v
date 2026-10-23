`timescale 1ns / 1ps

module main_controller (
    input tick,
    input rst,
    input [3:0] clean_btn,
    input [7:0] sw,
    output [13:0] seg_data,
    output reg [15:0] led
);

  // CLOCK, TIMER, START, STOP, IDLE
  parameter CLOCK             = 3'b000;
  parameter TIMER             = 3'b001;
  parameter START             = 3'b010;
  parameter STOP              = 3'b100;
  parameter IDLE              = 3'b111;

  parameter DELAY_CNT         = 5000;    // IDLE after 5 seconds delay

  parameter MS_CNT            = 1000;    // count 1000ms (1sec)
  parameter SEC_CNT           = 60;      // count 60 sec (1min)
  parameter MIN_CNT           = 100;     // maximum value  100

  parameter STOPWATCH_SEC_CNT = 100;     // maximum value 100
  parameter STOPWATCH_MS_CNT  = 1000;    // count 1 sec

  reg [                          2:0] r_mode = CLOCK;

  reg [        $clog2(DELAY_CNT)-1:0] r_delay_cnt = 0;

  reg [           $clog2(MS_CNT)-1:0] r_ms_cnt = 0;
  reg [          $clog2(SEC_CNT)-1:0] r_sec_cnt = 0;
  reg [          $clog2(MIN_CNT)-1:0] r_min_cnt = 0;

  reg [ $clog2(STOPWATCH_MS_CNT)-1:0] r_stopwatch_ms_cnt = 0;
  reg [$clog2(STOPWATCH_SEC_CNT)-1:0] r_stopwatch_sec_cnt = 0;

  reg [                          3:0] r_prev_btn = 0;

  // 1. check btn input & 5 seconds delay in STOP mode
  always @(posedge tick, posedge rst) begin
    if (rst) begin
      r_mode <= CLOCK;
      r_prev_btn <= 4'b0000;
      r_delay_cnt <= 0;
    end else begin
      // btnl pressed (->STOPWATCH)
      if (clean_btn[0] && !r_prev_btn[0]) begin
        r_mode = TIMER;
        // btnR pressed (->CLOCK)
      end else if (clean_btn[1] && !r_prev_btn[1]) begin
        r_mode = CLOCK;
        // btnU pressed (->START)
      end else if (clean_btn[2] && !r_prev_btn[2]) begin
        r_mode = (r_mode != CLOCK) ? START : CLOCK;
        // btnD pressed (->STOP)
      end else if (clean_btn[3] && !r_prev_btn[3]) begin
        r_mode = (r_mode == START) ? STOP : r_mode;
        // count r_delay_cnt to detect 5000ms(5sec) delay 
        // since detected, r_mode turns into IDLE mode
      end else if (r_mode != STOP) begin
        r_delay_cnt <= 0;
      end else if (r_delay_cnt == DELAY_CNT - 1) begin
        r_delay_cnt <= 0;
        r_mode = IDLE;
      end else begin
        r_delay_cnt <= r_delay_cnt + 1;
      end
      r_prev_btn <= clean_btn;
    end
  end

  // 2. calculate (minute, second) in CLOCK | (second, milli-second) in TIMER
  always @(posedge tick, posedge rst) begin
    if (rst) begin
      r_sec_cnt <= 0;
      r_min_cnt <= 0;
      r_ms_cnt <= 0;
      r_stopwatch_sec_cnt <= 0;
      r_stopwatch_ms_cnt <= 0;
    end else begin
      // CLOCK 
      if (r_mode == CLOCK) begin
        // r_min_cnt maximum value : 99 < 2^7(128)
        led[12:6] <= r_min_cnt;
        // r_sec_cnt maximum value : 59 < 2^6(64)
        led[5:0]  <= r_sec_cnt;

        // START
      end else if (r_mode == TIMER) begin
        r_stopwatch_sec_cnt <= 0;
        r_stopwatch_ms_cnt  <= 0;
        led[10:0] = 11'b0;
      end else if (r_mode == START) begin
        if (r_stopwatch_ms_cnt == STOPWATCH_MS_CNT - 1) begin
          r_stopwatch_ms_cnt  <= 0;
          r_stopwatch_sec_cnt <= r_stopwatch_sec_cnt + 1;
        end else begin
          r_stopwatch_ms_cnt <= r_stopwatch_ms_cnt + 1;
        end

        led[3:0]  <= r_stopwatch_ms_cnt / 100;
        led[10:4] <= r_stopwatch_sec_cnt;
      end
      // increases every 1ms regardless of mode
      r_ms_cnt <= r_ms_cnt + 1;
      // resets when ms_cnt reaches its maximum value 1000
      if (r_ms_cnt == MS_CNT - 1) begin
        r_ms_cnt  <= 0;
        r_sec_cnt <= r_sec_cnt + 1;
        // resets when sec_cnt reaches its maximum value 100
      end else if (r_sec_cnt == SEC_CNT) begin
        r_sec_cnt <= 0;
        r_min_cnt <= r_min_cnt + 1;
        // resets when min_cnt reaches its maximum value 100
      end else if (r_min_cnt == MIN_CNT) begin
        r_min_cnt <= 0;
        r_sec_cnt <= 0;
        r_ms_cnt  <= 0;
      end
    end
  end

  // 3. display mode 
  always @(r_mode) begin
    case (r_mode)
      CLOCK: begin
        led[15:13] = CLOCK;
      end
      TIMER: begin
        led[15:13] = TIMER;
      end
      START: begin
        led[15:13] = START;
      end
      STOP: begin
        led[15:13] = STOP;
      end
      IDLE: begin
        led[15:13] = IDLE;
      end
      default: begin
        led[15:13] = CLOCK;
      end
    endcase

  end

  // when mode is IDLE, fnd output is 9999
  assign seg_data =
    (r_mode == CLOCK)
        ? (r_min_cnt * 100 + r_sec_cnt)
        : ((r_mode != IDLE) ? (r_stopwatch_sec_cnt * 100 + r_stopwatch_ms_cnt / 10) : 9999);

endmodule
