`timescale 1ns / 1ps

module tb_mux_4bit;
  reg [3:0] a, b;
  reg        sel;
  wire [3:0] out;

  mux_4bit dut (
      .a  (a),
      .b  (b),
      .sel(sel),
      .out  (out)
  );

  initial begin
    a   = 0;
    b   = 0;
    sel = 0;

    #10 a = 4'b0011;
    b = 4'b1100;
    #10 sel = 1;
    #10 sel = 0;
  end
endmodule
