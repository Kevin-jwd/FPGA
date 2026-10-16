`timescale 1ns / 1ps

module priority_encoder (
    input [3:0] a,
    output reg [1:0] out,
    output v
);

  assign v = |a;

  always @(*) begin
    if (a[3]) {out[1], out[0]} = 2'b11;
    else if (a[2]) {out[1], out[0]} = 2'b10;
    else if (a[1]) {out[1], out[0]} = 2'b01;
    else {out[1], out[0]} = 2'b00;
  end
endmodule

