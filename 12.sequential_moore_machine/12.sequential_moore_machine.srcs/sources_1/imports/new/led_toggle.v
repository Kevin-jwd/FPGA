`timescale 1ns / 1ps

module led_toggle (
    input  btn,
    input  rst,
    output led2
);

  reg r_toggle = 1'b0;

  always @(posedge btn, posedge rst) begin
    if (rst) r_toggle = 1'b0;
    else r_toggle <= ~r_toggle;
  end

  assign led2 = r_toggle;
endmodule
