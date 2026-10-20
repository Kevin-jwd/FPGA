`timescale 1ns / 1ps

module my_fsm_moore (
    input  rst,
    input  clk,
    input  x_in,
    input  btnU,
    input  btnD,
    output y_out
);

  localparam [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

  reg [1:0] curr_state, next_state;

  // 1. curr state register 
  always @(posedge clk, posedge rst) begin
    if (rst) curr_state <= S0;
    else curr_state <= next_state;
  end

  // 2. next state register
  always @(*) begin
    case (curr_state)
      S0: next_state = x_in ? S1 : S0;
      S1: next_state = !x_in ? S2 : S1;
      S2: next_state = x_in ? S3 : S0;
      S3: next_state = x_in ? S1 : S2;
      default: next_state = S0;
    endcase
  end

  // 3. only depend on current state
  assign y_out = (curr_state == S3);

endmodule
