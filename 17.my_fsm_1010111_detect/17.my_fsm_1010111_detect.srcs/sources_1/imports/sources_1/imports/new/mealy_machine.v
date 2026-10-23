`timescale 1ns / 1ps
module mealy_machine (
    input clk,
    input rst,
    input btn_press,
    input data_in,
    output [15:0] led
);
  localparam [2:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6;
  reg [2:0] r_curr_state, r_next_state;
  reg [6:0] history;
  reg detected;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      r_curr_state <= S0;
      history <= 0;
      detected <= 0;
    end else if (btn_press) begin
      r_curr_state <= r_next_state;
      history <= {history[5:0], data_in};
      if (r_curr_state == S6 && data_in) detected <= 1;
    end
  end

  always @(*) begin
    r_next_state = r_curr_state;
    case (r_curr_state)
      S0: r_next_state = data_in ? S1 : S0;
      S1: r_next_state = data_in ? S1 : S2;
      S2: r_next_state = data_in ? S3 : S0;
      S3: r_next_state = data_in ? S1 : S4;
      S4: r_next_state = data_in ? S5 : S0;
      S5: r_next_state = data_in ? S6 : S4;
      S6: r_next_state = data_in ? S1 : S2;
    endcase
  end

  assign led = {detected, 8'b0, history};
endmodule
