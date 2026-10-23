`timescale 1ns / 1ps

module shift_register (
    input clk,
    input rst,
    input btn_press,
    input x,
    output [15:0] led
);
  // 버튼을 눌렀다 뗀 순간 shift

  reg [6:0] sr7;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      sr7 <= 7'b0000000;
    end else if (btn_press) begin
      sr7 <= {sr7[5:0], x};  // shift register
    end
  end


  assign led[6:0]  = sr7;
  assign led[14:7] = 8'b00000000;
  assign led[15]   = (sr7 == 7'b1010111) ? 1 : 0;

endmodule


