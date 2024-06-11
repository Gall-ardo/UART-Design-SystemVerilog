`timescale 1ns / 1ps

module HexTo7Segment
(
    input logic clk,
    input logic [7:0] currentHexadecimal,
    output logic [0:6] display1,
    output logic [0:6] display0 
);

    function [0:6] decodeHexTo7Segment(input [3:0] hexDigit);
        case (hexDigit)
        4'h0: decodeHexTo7Segment = 7'b0000001; // 0
        4'h1: decodeHexTo7Segment = 7'b1001111; // 1
        4'h2: decodeHexTo7Segment = 7'b0010010; // 2
        4'h3: decodeHexTo7Segment = 7'b0000110; // 3
        4'h4: decodeHexTo7Segment = 7'b1001100; // 4
        4'h5: decodeHexTo7Segment = 7'b0100100; // 5
        4'h6: decodeHexTo7Segment = 7'b0100000; // 6
        4'h7: decodeHexTo7Segment = 7'b0001111; // 7
        4'h8: decodeHexTo7Segment = 7'b0000000; // 8
        4'h9: decodeHexTo7Segment = 7'b0000100; // 9
        4'hA: decodeHexTo7Segment = 7'b0001000; // A
        4'hB: decodeHexTo7Segment = 7'b1100000; // B
        4'hC: decodeHexTo7Segment = 7'b0110001; // C
        4'hD: decodeHexTo7Segment = 7'b1000010; // D
        4'hE: decodeHexTo7Segment = 7'b0110000; // E
        4'hF: decodeHexTo7Segment = 7'b0111000; // F
        default: decodeHexTo7Segment = 7'b1111111; // blank
        endcase
    endfunction

    always_ff @(posedge clk) begin
        display1 <= decodeHexTo7Segment(currentHexadecimal[7:4]);
        display0 <= decodeHexTo7Segment(currentHexadecimal[3:0]);
    end

endmodule
