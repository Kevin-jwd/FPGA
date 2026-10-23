`timescale 1ns / 1ps

module tb_LED_fsm ();

  reg clk;
  reg rst;
  reg btnC;
  wire [4:0] led;

  top_led_fsm u_top_led_fsm (
      .clk (clk),
      .rst (rst),
      .btnC(btnC),
      .led (led)
  );

  initial begin
    clk = 1'b0;
    forever begin
      #(10 / 2) clk = ~clk;
    end
  end

  initial begin
    rst  = 1'b1;
    btnC = 1'b0;

    #100 rst = 1'b0;
    $display("[%0t] Start simulation ............", $time);

    #100 btnC = 1'b1;
    #20000000 btnC = 1'b0;
    #20000000 btnC = 1'b1;
    #20000000 btnC = 1'b0;
    #20000000 btnC = 1'b1;
    #20000000 btnC = 1'b0;
    #20000000 btnC = 1'b1;
    #20000000 btnC = 1'b0;
    #20000000 btnC = 1'b1;
    #20000000 btnC = 1'b0;
    #20000000 btnC = 1'b1;
    #20000000 btnC = 1'b0;
    
    #1000 $display("[%0t] Finishing task ..............", $time);
  end
endmodule
