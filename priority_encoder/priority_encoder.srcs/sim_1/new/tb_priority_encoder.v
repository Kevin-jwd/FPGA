`timescale 1ns / 1ps

// 입력 reg, 출력 wire
module tb_priority_encoder;
  reg [3:0] a;
  wire [1:0] out;
  wire v;

  priority_encoder u_priority_encoder (
      .a  (a),
      .out(out),
      .v  (v)
  );

  initial begin
    a = 4'b0000;
    #10 a = 4'b0001;
    #10 a = 4'b0010;
    #10 a = 4'b0011;
    #10 a = 4'b0100;
    #10 a = 4'b0111;
    #10 a = 4'b1000;
    #10 a = 4'b1111;
    #10 a = 4'b0000;
  end
endmodule
