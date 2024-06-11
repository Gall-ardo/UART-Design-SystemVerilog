`timescale 1ns / 1ps

module baudClock
#( parameter BAUD_RATE = 115200, parameter BAUD_FREQ = 100000000/BAUD_RATE)
(
    input logic clk,
    output logic slw_clk
    );
    
    logic [30:0] counter;

    always_ff @(posedge clk) begin
        if (counter == BAUD_FREQ) begin
            counter <= 0;
            slw_clk <= ~slw_clk;
        end else begin
            counter <= counter + 1;
        end        
    end
 
endmodule
