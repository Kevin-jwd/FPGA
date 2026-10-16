`timescale 1ns / 1ps

module up_counter (
    input clk,
    input rst,
    input [1:0] clean_btn,
    output reg [15:0] led
);

  reg  [$clog2(10)-1:0] r_cnt = 0;
  reg                   mode = 0;  // RUN
  reg  [           1:0] prev_btn = 0;

  wire                  pressU;
  wire                  pressD;

  assign pressU = clean_btn[0] & ~prev_btn[0];
  assign pressD = clean_btn[1] & ~prev_btn[1];

  initial begin
    led = 1'h0;
  end

  always @(posedge clk, posedge rst) begin
    // reset
    if (rst) begin
      led <= 16'h0;
      r_cnt <= 0;
      mode <= 0;
      prev_btn <= 0;
    end else begin
      prev_btn <= clean_btn;

      if (pressU) begin
        mode <= ~mode;
      end else if (mode == 1) begin
        if (pressD) begin
          led   <= 0;
          r_cnt <= 0;
        end
      end else begin
        if (r_cnt == (10 - 1)) begin
          r_cnt <= 0;
          led   <= led + 1;
        end else begin
          r_cnt <= r_cnt + 1;
        end
      end
    end
  end

endmodule
