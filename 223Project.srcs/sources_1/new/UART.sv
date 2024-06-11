`timescale 1ns / 1ps

module UART
 #(parameter DATA_WIDTH = 8,BAUD_RATE  = 115200)
(
    input logic clk,
    input logic rx_line,
    input logic transmit_enable,
    
    input logic auto_transmit_enable, // sw[15]
    
    input logic load_enable,
    input logic btnL,
    input logic btnR,
    input logic btnU,
    input logic [DATA_WIDTH-1:0] sw,
    
    output logic tx_line,
    output logic [7:0] led,
    output logic [7:0] led2,
    output logic [0:6] seg,
    output logic [3:0] an
    );
    
    logic [DATA_WIDTH-1:0] txbuf0, txbuf1, txbuf2, txbuf3;
    logic [DATA_WIDTH-1:0] rxbuf0, rxbuf1, rxbuf2, rxbuf3;
    logic tx_busy, rx_ready;
    

    TXBUF #(
        .DATA_WIDTH(DATA_WIDTH),
        .BAUD_RATE(BAUD_RATE)
    ) tx_buffer (
        .clk(clk),
        .transmit_enable(transmit_enable),
        .auto_transmit_enable(auto_transmit_enable),
        .load_enable(load_enable),
        .sw(sw),
        .txbuf0(txbuf0),
        .txbuf1(txbuf1),
        .txbuf2(txbuf2),
        .txbuf3(txbuf3),
        .led(led),
        .tx_line(tx_line)
    );
    
    RXBUF #(
        .DATA_WIDTH(DATA_WIDTH),
        .BAUD_RATE(BAUD_RATE)
    ) rx_buffer (
        .clk(clk),
        .rx_line(rx_line),
        .rxbuf0(rxbuf0),
        .rxbuf1(rxbuf1),
        .rxbuf2(rxbuf2),
        .rxbuf3(rxbuf3),
        .led(led2),
        .error(rx_ready)
    );
    
    SevenSegmentController #(
        .DATA_WIDTH(DATA_WIDTH)
    ) display_controller (
        .clk(clk),
        .txbuf0(txbuf0),
        .txbuf1(txbuf1),
        .txbuf2(txbuf2),
        .txbuf3(txbuf3),
        .rxbuf0(rxbuf0),
        .rxbuf1(rxbuf1),
        .rxbuf2(rxbuf2),
        .rxbuf3(rxbuf3),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .seg(seg),
        .an(an)
    );    
    
endmodule
