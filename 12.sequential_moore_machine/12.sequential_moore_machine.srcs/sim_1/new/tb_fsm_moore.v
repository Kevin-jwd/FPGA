`timescale 1ns / 1ps

module tb_fsm_moore ();

  reg  clk = 0;
  reg  rst = 0;
  reg  x_in = 0;
  wire y_out;

  reg  r_error = 1'b0;

  top_fsm_moore u_top_moore (
      .clk  (clk),
      .rst  (rst),
      .x_in (x_in),
      .y_out(y_out)
  );

  always #5 clk = ~clk;

  // Before rising check if y_out changed
  task send_data(input a, input expect_val);
    begin
      x_in = a;
      #1;  // gate 동작

      @(posedge clk);
      #1;

      // print error message if y is not expected value
      if (y_out !== expect_val) begin

        r_error = 1'b1;
        $display("FAIL t=%0t | x=%b | y=%b | expected_val=%b", $time, a, y_out, expect_val);

      end
    end
  endtask

  // 10101101
  initial begin
    #100 rst = 1;
    #100 rst = 0;
    
    send_data(1, 0);
    send_data(0, 0);
    send_data(1, 1);
    send_data(0, 0);
    send_data(1, 1);
    send_data(1, 0);
    send_data(0, 0);
    send_data(1, 1);

    if (r_error == 0) $display("PASS moore FSM !!!!!!");
    else $display("FAILED moore FSM !!!!!!");

    $finish;

  end



endmodule
