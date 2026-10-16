`timescale 1ns / 1ps

module tb_gates ();

  // 입력은 i_ (input), 출력은 o_ (output)

  // 입력은 reg로 선언
  reg [1:0] i_sw;

  // 출력은 wire로 선언
  wire [5:0] o_led;

  // gates 인스턴스 생성
  gates u_gates (
      .a  (i_sw[0]),
      .b  (i_sw[1]),
      .led(o_led)
  );

  // initial 은 simulation당 한 번만 실행
  initial begin
    // #20: 20ns 딜레이
    // 00
    #00 i_sw[0] = 1'b0;
    i_sw[1] = 1'b0;
    // 01
    #20 i_sw[0] = 1'b0;
    i_sw[1] = 1'b1;
    // 10
    #20 i_sw[0] = 1'b1;
    i_sw[1] = 1'b0;
    // 11
    #20 i_sw[0] = 1'b1;
    i_sw[1] = 1'b1;
    // 총 80ns 경과 후 시뮬레이션 종료
    #20 $stop;
  end

endmodule

