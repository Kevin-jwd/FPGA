`timescale 1ns / 1ps

module mealy_machine (
    input clk,
    input rst,
    input btnC,
    output [4:0] led
);

  // Encoding (S3 is unnecessary)
  localparam [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
  localparam CLOCKWISE = 1'b0, REV_CLOCKWISE = 1'b1;

  reg [1:0] r_curr_state = S0, r_next_state = S0;
  reg curr_dir, next_dir;

  // 1. curr_state register (same as moore machine
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      r_curr_state <= S0;
      curr_dir <= CLOCKWISE;
    end else begin
      r_curr_state <= r_next_state;
      curr_dir <= next_dir;
    end
  end

  always @(*) begin
    r_next_state = r_curr_state;
    next_dir = curr_dir;

    case (r_curr_state)
      S0: begin
        next_dir = CLOCKWISE;
        if (btnC) begin
          r_next_state = S1;
        end
      end
      S1: if (btnC) r_next_state = (curr_dir == CLOCKWISE) ? S2 : S0;
      S2: if (btnC) r_next_state = (curr_dir == CLOCKWISE) ? S3 : S1;
      S3: begin
        next_dir = REV_CLOCKWISE;
        if (btnC) begin
          r_next_state = S2;

        end
      end
      default: begin
        r_next_state = S0;
        next_dir = CLOCKWISE;
      end
    endcase
  end

  assign led = {curr_dir, (4'b0001 << r_curr_state)};

endmodule
