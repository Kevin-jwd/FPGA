`timescale 1ns / 1ps

module rom (
    input [3:0] addr,
    input oe,
    output reg [7:0] dataout
);

  always @(*) begin
    case (oe)
      1'b1:
      case (addr)
        4'h0: dataout = 'h23;
        4'h1: dataout = 'hf3;
        4'h2: dataout = 'hfa;
        4'h3: dataout = 'ha2;
        4'h4: dataout = 'hc3;
        4'h5: dataout = 'hb4;
        4'h6: dataout = 'h07;
        4'h7: dataout = 'h70;
        4'h8: dataout = 'hcc;
        4'h9: dataout = 'hbb;
        4'ha: dataout = 'h54;
        4'hb: dataout = 'h4c;
        4'hc: dataout = 'h7a;
        4'hd: dataout = 'ha8;
        4'he: dataout = 'h99;
        4'hf: dataout = 'hff;
        default: dataout = 'hz;
      endcase
      default: dataout = 'hz;
    endcase
  end
endmodule

