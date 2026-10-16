`timescale 1ns / 1ps

module D_FF (
    input clk,
    input rst,
    input d,
    output reg q
);

  always @(posedge clk, posedge rst) begin
    if (rst) q <= 0;
    else q <= d;

  end
endmodule
