// `timescale 시간 단위 / 시간 해상도
`timescale 1ns / 1ps

module gates (
    // input: 입력, output: 출력, inout: 입출력
    // wire 생략 시 default로 wire로 인식
    input [1:0] sw,
    output [5:0] led
);

  // assign: 연속 할당문 (회로도처럼 동시 실행)
  assign led[0] = sw[0] & sw[1];  // AND
  assign led[1] = sw[0] | sw[1];  // OR
  assign led[2] = ~(sw[0] & sw[1]);  // NAND
  assign led[3] = ~(sw[0] | sw[1]);  // NOR
  assign led[4] = sw[0] ^ sw[1];  // XOR
  assign led[5] = ~sw[0];  // NOT
endmodule

// module: 모듈 시작, endmodule: 모듈 끝
// module gates (
//     // input: 입력, output: 출력, inout: 입출력
//     input  a,
//     input  b,
//     output ld0,
//     output ld1,
//     output ld2,
//     output ld3,
//     output ld4,
//     output ld5
// );

//   // assign: 연속 할당문 (회로도처럼 동시 실행)
//   assign ld0 = a & b;  // AND
//   assign ld1 = a | b;  // OR
//   assign ld2 = ~(a & b);  // NAND
//   assign ld3 = ~(a | b);  // NOR
//   assign ld4 = a ^ b;  // XOR
//   assign ld5 = ~a;  // NOT
// endmodule
