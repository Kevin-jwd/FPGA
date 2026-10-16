`timescale 1ns / 1ps

module tb_mux2_1 ();
  // 1. 입력: reg 선언, 출력: wire 선언
  reg a, b, sel;
  wire out;

  //2. 검증할 모듈 인스턴스 생성
  mux2_1 u_mux2_1 (
      .a  (a),
      .b  (b),
      .sel(sel),
      .out(out)
  );

  // 3. 테스트 시나리오 작성
  initial begin
    // 초깃값 설정
    a   = 1'b0;
    b   = 1'b0;
    sel = 1'b0;

    // 결과 화면에 출력
    $monitor("Time = %0t | sel = %b | a =  %b | b = %b | out = %b", $time, sel, a, b, out);

    // -- sel = 0, b 출력 --

    // b = 0
    #10;
    sel = 1'b0;
    a   = 1'b1;
    b   = 1'b0;

    // b = 1
    #10;
    sel = 1'b0;
    a   = 1'b1;
    b   = 1'b1;

    // a = 0
    #10;
    sel = 1'b1;
    a   = 1'b1;
    b   = 1'b0;

    // a = 0
    #10;
    sel = 1'b1;
    a   = 1'b0;
    b   = 1'b1;

    // 10ns 대기 후 종룐
    #10;
    $finish;

  end

endmodule
