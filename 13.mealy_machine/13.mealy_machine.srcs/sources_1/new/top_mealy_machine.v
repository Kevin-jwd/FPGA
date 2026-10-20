`timescale 1ns / 1ps

module top_mealy_machine (
    input  btnU,
    input  btnD,
    input  rst,
    input  clk,
    output moore_y,
    output mealy_y
);

  wire [1:0] clean_btn;
  wire w_moore_y;
  wire w_mealy_y;

  btn_debounce u_button_debounce (
      .clk(clk),
      .rst(rst),
      .btnU(btnU),
      .btnD(btnD),
      .clean_btn(clean_btn)
  );

  mealy_machine u_mealy_machine (
      .clk(clk),
      .rst(rst),
      .x_U(clean_btn[0]),
      .x_D(clean_btn[1]),
      .y  (w_mealy_y)
  );

  my_fsm_moore u_moore_machine (
      .clk(clk),
      .rst(rst),
      .x_U(clean_btn[0]),
      .x_D(clean_btn[1]),
      .y  (w_moore_y)
  );

  assign moore_y = w_moore_y;
  assign mealy_y = w_mealy_y;
  
endmodule
