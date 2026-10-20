`timescale 1ns / 1ps

module btn_debounce (
    input clk,
    input rst,
    input btnU,
    input btnD,
    output reg [1:0] clean_btn
);

  reg [$clog2(1_000_000)-1:0] cntU, cntD;

  initial begin
    cntU = 0;
    cntD = 0;
    clean_btn = 2'b00;
  end

  always @(posedge clk or posedge rst) begin
    // **** reset **** 
    if (rst) begin
      cntU <= 0;
      cntD <= 0;
      clean_btn <= 2'b00;


    end else begin
      // btnU
      if (btnU == clean_btn[0]) begin
        cntU <= 0;
      end else if (cntU == (1_000_000 - 1)) begin
        cntU <= 0;
        clean_btn[0] <= btnU;
      end else begin
        cntU <= cntU + 1;
      end

      // btnD
      if (btnD == clean_btn[1]) begin
        cntD <= 0;
      end else if (cntD == (1_000_000 - 1)) begin
        cntD <= 0;
        clean_btn[1] <= btnD;
      end else begin
        cntD <= cntD + 1;
      end
    end
  end
endmodule
