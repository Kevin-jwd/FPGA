`timescale 1ns / 1ps

module clock_80Hz #(
    parameter DIV = 1_250_000  // default: 80Hz --> 시뮬레이션에서 작은 값으로 overriding
                               // 외부에서 값을 지정하지 않으면 default로 동작ㄴ
) (
    input clk,
    input rst,
    output reg o_clk
);

  // reg [23:0] r_cnt = 0;          // 1,250,000 => 10ns * 1,250,000 = 12.5ms
  reg [$clog2(DIV)-1:0] r_cnt = 0;  // 1,250,000 => 10ns * 1,250,000 = 12.5ms

  initial begin
    o_clk = 1'b0;
  end

  always @(posedge clk, posedge rst) begin
    // 비동기 reset 0 --> 1
    if (rst) begin
      o_clk <= 0;
      r_cnt <= 0;
    end else begin
      if (r_cnt == (DIV / 2) - 1) begin
        r_cnt <= 0;
        o_clk <= ~o_clk;
      end else begin
        r_cnt <= r_cnt + 1;
      end
    end
  end

endmodule
