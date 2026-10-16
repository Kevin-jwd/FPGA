`timescale 1ns / 1ps

module mux (
    input btnU,
    input btnD,
    input sel,
    output reg btn
);

  always @(sel, btnD, btnU) begin
    if (sel) btn = btnD;
    else btn = btnU;
  end


endmodule
