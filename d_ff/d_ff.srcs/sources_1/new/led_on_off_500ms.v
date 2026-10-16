`timescale 1ns / 1ps

module led_on_off_500ms (
    input tick,
    output reg led1
);

  reg [$clog2(500):0] r_cnt = 0;
  initial begin
    led1 = 1'b0;
  end

  always @(posedge tick) begin
    if (r_cnt == 500 - 1) begin
      r_cnt <= 0;
      led1  <= ~led1;
    end else begin
      r_cnt <= r_cnt + 1;
    end
  end
endmodule
