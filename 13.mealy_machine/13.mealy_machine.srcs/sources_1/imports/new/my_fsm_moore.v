`timescale 1ns / 1ps

module my_fsm_moore (
    input  clk,
    input  rst,
    input  x_U,
    input  x_D,
    output reg y
);

  localparam [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

  reg [1:0] curr_state, next_state;
  reg u_handled, d_handled;

  // 1. curr_state register (same as moore machine
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      curr_state <= S0;
      y <= 1'b0;
      u_handled  <= 1'b0;
      d_handled  <= 1'b0;
    end else begin

      if (!x_U) u_handled <= 1'b0;
      if (!x_D) d_handled <= 1'b0;

      if (x_U && !u_handled) begin
        u_handled <= 1'b1;
        y <= (curr_state == S3);

        case (curr_state)
          S0: curr_state <= S1;
          S1: curr_state <= S1;
          S2: curr_state <= S3;
          S3: curr_state <= S1;
          default: curr_state <= S0;
        endcase

        // 동시 입력 시 U 우선
      end else if (x_D && !d_handled) begin
        d_handled <= 1'b1;
        y <= (curr_state == S3);

        case (curr_state)
          S0: curr_state <= S0;
          S1: curr_state <= S2;
          S2: curr_state <= S0;
          S3: curr_state <= S2;
          default: curr_state <= S0;
        endcase
      end
    end
  end



endmodule
