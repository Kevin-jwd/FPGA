`timescale 1ns / 1ps

module tick_generator #(
    parameter DIV = 100_000
) (
    input clk,
    input rst,
    output reg tick
);

  reg [$clog2(DIV)-1:0] r_cnt = 0;

  initial begin
    tick = 1'b0;
  end

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      tick  <= 0;
      r_cnt <= 0;
    end else begin
      if (r_cnt == DIV - 1) begin
        r_cnt <= 0;
        tick  <= 1'b1;
      end else begin
        tick  <= 1'b0;
        r_cnt <= r_cnt + 1;
      end
    end
  end
endmodule
