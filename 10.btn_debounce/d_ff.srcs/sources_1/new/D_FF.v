`timescale 1ns / 1ps

module D_FF (
    input o_clk,
    input rst,
    input d,
    output reg q
);

  always @(posedge o_clk, posedge rst) begin
    if (rst) q <= 0;
    else q <= d;

  end
endmodule
