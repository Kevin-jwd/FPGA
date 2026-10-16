`timescale 1ns / 1ps

module tb_rom ();

  reg [3:0] addr;
  reg oe;
  wire [7:0] dataout;

  rom u_rom (
      .addr(addr),
      .oe(oe),
      .dataout(dataout)
  );

  initial begin
    addr = 'h0;
    oe   = 'b0;
    #10 oe = 'b1;
    addr = 'h1;
    #10 addr = 'h2;
    #10 addr = 'h3;
    #10 addr = 'h4;
    #10 addr = 'h5;
    #10 addr = 'h6;
    #10 addr = 'h7;
    #10 addr = 'h8;
    #10 addr = 'h9;
    #10 addr = 'ha;
    #10 addr = 'hb;
    #10 addr = 'hc;
    #10 addr = 'hd;
    #10 addr = 'he;
    #10 addr = 'hf;
    #10 $finish;
  end
endmodule
