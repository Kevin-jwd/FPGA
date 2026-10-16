`timescale 1ns / 1ps



module tb_top_button_debounce ();

  parameter  CLK_FREQ        = 100_000_000;                  // 100MHz
  parameter  CLK_PERIOD      = 10;                           // 10ns

  // -- 시뮬레이션 시간 비 조정 --
  // 실제 보드동작 분주비 : DIV = 1_250_000 (1주기 12.5ms, 80Hz)
  // 시뮬레이션 분주비 : DIV = 100 (1주기 1us, 1MHz)
  // 실제 보드 동작 비 보다 12,500배 단축
  parameter  SIMULATION_DIV  = 100;                          // 1MHz
  localparam SAMPLE_PERIOD   = SIMULATION_DIV * CLK_PERIOD;  // 1000ns (1us)

  // 버튼을 누르고 있는 시간
  // sample clk 3주기 동안 누르고 있다고 설정
  parameter  BTN_PRESS_LIMIT = SAMPLE_PERIOD * 3;

  // clock 80Hz의 분주비를 시뮬레이션용 분주비 값으로 overriding
  defparam top_button_debounce.u_button_debounce.u_clock_80Hz.DIV = SIMULATION_DIV;

  reg  btnC;
  reg  clk;
  reg  rst;
  wire led;
  wire led1;

  top_button_debounce u_top_button_debounce (
      .btnC(btnC),
      .clk (clk),
      .rst (rst),
      .led (led),
      .led1(led1)
  );

  // Clock generation
  initial begin
    clk = 1'b0;
    forever begin
      #(CLK_PERIOD / 2) clk = ~clk;
    end
  end

  initial begin
    rst  = 1'b1;
    btnC = 1'b0;
    #100 rst = 1'b0;
    $display("[%0t] start noise sig generation ..............", $time);
    #100;

    btnC = 1'b1;
    #200 btnC = 1'b0;
    #300 btnC = 1'b1;
    #120 btnC = 1'b0;
    #500 btnC = 1'b1;
    #(BTN_PRESS_LIMIT);
    #10
    if (led == 1'b1) begin
      $display("[%0t] SIM test success ..............", $time);
    end else begin
      $display("[%0t] SIM test failed ..............", $time);
    end
    #1000 $display("[%0t] Finishing task ..............", $time);
    $finish;
  end

endmodule
