`timescale 1ns / 1ps

module tb_adder8 ();
  reg [6:0] a;  // 시물레이션에서 입력은 reg
  reg [6:0] b;
  reg cin;  // 1bit
  wire [6:0] sum;  // 시물레이션에서 출력은 wire로 선언
  wire cout;

  adder8 dut (
      .a(a),
      .b(b),
      .cin(cin),  // 1bit
      .sum(sum),
      .cout(cout)
  );

  initial begin
    a   = 8'h00;
    b   = 8'h00;
    cin = 1'b0;

    #10 a = 8'h40;
    b   = 8'h40;
    cin = 1'b0;  // 64 + 64 = 128
    #10 a = 8'h80;
    b   = 8'h01;
    cin = 1'b0;  // 128 + 1 = 129
    #10 a = 8'hC0;
    b   = 8'h20;
    cin = 1'b0;  // 192 + 32 = 224
    #10 a = 8'h7F;
    b   = 8'h00;
    cin = 1'b1;  // 127 + cin = 128
    #10 a = 8'hFF;
    b   = 8'h00;
    cin = 1'b1;  // cout=1, sum=0
    #10 a = 8'hFF;
    b   = 8'hFF;
    cin = 1'b0;  // cout=1, sum=254
    #10 a = 8'hAA;
    b   = 8'h55;
    cin = 1'b0;  // 10101010 + 01010101

    #10 $finish;
  end

endmodule
