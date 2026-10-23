`timescale 1ns / 1ps

module led_logic (
    input btnC,
    input clk,
    input rst,
    output reg [3:0] led
);

  always @(posedge clk, posedge rst) begin
    if (rst) led = 4'b0000;
    else begin
        
    end

  end

  always @(posedge btnC) begin


  end

endmodule
