`timescale 1ns / 1ps

module mux_4bit (
    input [3:0] a,
    input [3:0] b,
    input sel,
    output reg [3:0] out
);

  always @(sel, a, b) begin
    case (sel)
      1'b1: out = a;
      1'b0: out = b;
    endcase
  end
endmodule
