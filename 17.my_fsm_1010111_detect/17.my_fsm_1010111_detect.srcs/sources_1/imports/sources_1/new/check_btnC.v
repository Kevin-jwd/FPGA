`timescale 1ns / 1ps

module check_btnC(
    input clk,
    input reset,   // 비동기 reset, active-high
    input clean_btnC,
    output btn_press  
    );

    reg r_prev_c;
    wire w_release_c;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_prev_c <= 1'b0;
        end else begin
            r_prev_c <= clean_btnC;
        end
    end

    assign w_release_c = r_prev_c & ~clean_btnC;   // btnD 뗀 순간

    assign btn_press = w_release_c;   // btnU 나 btnD 둘중 1개를 눌렀다 뗴면 

endmodule
