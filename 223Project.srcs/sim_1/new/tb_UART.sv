`timescale 1ns / 1ps

module tb_UART();

    parameter DATA_WIDTH = 8;
    parameter BAUD_RATE = 115200;

    // Clock generation
    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Generate a clock with a period of 10 ns
    end

    // Input and output signals
    logic rx_line;
    logic transmit_enable;
    logic auto_transmit_enable;
    logic load_enable;
    logic btnL, btnR, btnU;
    logic [DATA_WIDTH-1:0] sw;
    logic tx_line;
    logic [7:0] led, led2;
    logic [0:6] seg;
    logic [3:0] an;
    
    // Instantiate the UART module
    UART DUT (
        .clk(clk),
        .rx_line(rx_line),
        .transmit_enable(transmit_enable),
        .auto_transmit_enable(auto_transmit_enable),
        .load_enable(load_enable),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .sw(sw),
        .tx_line(tx_line),
        .led(led),
        .led2(led2),
        .seg(seg),
        .an(an)
    );
/*
    // Test sequence
    initial begin
        // Initialize all inputs
        transmit_enable = 0;
        auto_transmit_enable = 0;
        load_enable = 0;
        btnL = 1'b0;
        btnR = 1'b0;
        btnU = 1'b0;
        sw = 8'h00;

        // Load data into TXBUF
        load_enable = 1;
        sw = 8'hA5;  // Example data
        #10;
        load_enable = 0;
        #10;

        // Repeat for other bytes
        load_enable = 1;
        sw = 8'h5A;
        #10;
        load_enable = 0;
        #10;

        load_enable = 1;
        sw = 8'hF0;
        #10;
        load_enable = 0;
        #10;

        load_enable = 1;
        sw = 8'h0F;
        #10;
        load_enable = 0;
        #50;  // Wait some time before triggering transmission

        // Test automatic transmission
        auto_transmit_enable = 1;  // Enable auto transmission mode
        #10;
        transmit_enable = 1;  // Simulate pressing the transmit button
        #10;
        transmit_enable = 0;
        #1000; // Wait for transmission to complete

        // Additional tests can be added here
        // Finish simulation
        $finish;
    end*/

endmodule
