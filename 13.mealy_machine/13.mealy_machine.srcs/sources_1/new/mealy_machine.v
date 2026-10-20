`timescale 1ns / 1ps

module mealy_machine (
    input  clk,
    input  rst,
    input  x_U,
    input  x_D,
    output reg y
);

  // Encoding (S3 is unnecessary)
  localparam [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

  reg [1:0] r_curr_state, r_next_state;
  reg u_handled, d_handled;

  // 1. curr_state register (same as moore machine
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      r_curr_state <= S0;
      y <= 1'b0;
      u_handled <= 1'b0;
      d_handled <= 1'b0;
    end else begin

      if (!x_U) u_handled <= 1'b0;
      if (!x_D) d_handled <= 1'b0;

      if (x_U && !u_handled) begin
        u_handled <= 1'b1;
        y <= (r_curr_state == S2);

        case (r_curr_state)
          S0: r_curr_state <= S1;
          S1: r_curr_state <= S1;
          S2: begin
            r_curr_state <= S1;

          end
          default: r_curr_state <= S0;
        endcase

        // 동시 입력 시 U 우선
      end else if (x_D && !d_handled) begin
        d_handled <= 1'b1;
        y <= 1'b0;

        case (r_curr_state)
          S0: r_curr_state <= S0;
          S1: r_curr_state <= S2;
          S2: r_curr_state <= S0;
          default: r_curr_state <= S0;
        endcase
      end
    end
  end
  

endmodule
