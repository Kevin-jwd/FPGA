`timescale 1ns / 1ps

module btn_debounce (
    input clk,
    input btn,
    input rst,
    output reg clean_btn
);

  reg [$clog2(10)-1:0] r_cnt = 0;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      r_cnt <= 0;
      clean_btn <= 0;
    end else if (btn == clean_btn) begin
      r_cnt <= 0;
    end else if (r_cnt == (10 - 1)) begin
      r_cnt <= 0;
      clean_btn <= btn;
    end else begin
      r_cnt <= r_cnt + 1;
    end
  end

endmodule
