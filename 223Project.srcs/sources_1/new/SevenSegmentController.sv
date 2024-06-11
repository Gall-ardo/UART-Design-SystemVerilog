`timescale 1ns / 1ps
module SevenSegmentController
#(parameter DATA_WIDTH = 8)
(
    input logic clk,
    input logic [7:0] txbuf0,
    input logic [7:0] txbuf1,
    input logic [7:0] txbuf2,
    input logic [7:0] txbuf3,
    input logic [7:0] rxbuf0,
    input logic [7:0] rxbuf1,
    input logic [7:0] rxbuf2,
    input logic [7:0] rxbuf3,
    input logic btnL, // left
    input logic btnR, // right
    input logic btnU, // switch between TXBUF and RXBUF
    
    output logic [0:6] seg,
    output logic [3:0] an 
    );
    
    logic selectTx;  // 1 for TXBUF, 0 for RXBUF
    logic [1:0] txIndex, rxIndex;  // Current indices for TX and RX buffers
    
    initial begin
        selectTx = 0;
        txIndex = 2'b00;
        rxIndex = 2'b00;
    end
    
    logic btnLD, btnRD, btnUD;
    

    Debounce db_btnL (
        .clk(clk),
        .btn_in(btnL),
        .btn_out(btnLD)
    );

    Debounce db_btnR (
        .clk(clk),
        .btn_in(btnR),
        .btn_out(btnRD)
    );

    Debounce db_btnU (
        .clk(clk),
        .btn_in(btnU),
        .btn_out(btnUD)
    );
    
    always_ff @(posedge clk) begin
        if (btnLD) begin
            if (selectTx) begin
                if (txIndex == 0) txIndex <= 3;
                else txIndex <= txIndex - 1;
            end else begin
                if (rxIndex == 0) rxIndex <= 3;
                else rxIndex <= rxIndex - 1;
            end
        end
        if (btnRD) begin
            if (selectTx) begin
                txIndex <= (txIndex + 1) % 4;
            end else begin
                rxIndex <= (rxIndex + 1) % 4;
            end
        end
        if (btnUD) begin
            selectTx <= ~selectTx;
        end
    end
    

    /*logic btnLdebouncer = 0;
    logic btnRdebouncer = 0;
    logic btnUdebouncer = 0;
    always_ff @(posedge clk) begin
        if (btnL & ~btnLdebouncer) begin
            if (selectTx) begin
                if (txIndex == 0) txIndex <= 3;
                else txIndex <= txIndex - 1;
            end else begin
                if (rxIndex == 0) rxIndex <= 3;
                else rxIndex <= rxIndex - 1;
            end
            btnLdebouncer <= 1;
        end
        else if (~ btnL)begin
            btnLdebouncer <= 0;
        end
        if (btnR & ~btnRdebouncer) begin
            if (selectTx) begin
                txIndex <= (txIndex + 1) % 4;
            end else begin
                rxIndex <= (rxIndex + 1) % 4;
            end
            btnRdebouncer <=1;
        end else if(~btnR)begin
            btnRdebouncer <= 0;
        end
        if (btnU & ~btnUdebouncer) begin
            selectTx <= ~selectTx;
            btnUdebouncer <= 1;
        end
        else if(~btnU)begin
            btnUdebouncer <= 0;
        end
    end*/
 
    logic [6:0] display3,display2,display1, display0;// 3 is leftmost
    logic [7:0] currentHexadecimal;
     
    always @(posedge clk) begin
        if(selectTx)begin 
            display3 = 7'b1110000; // display 3 is t
            case(txIndex)
                2'b00: begin
                    display2 = 7'b0000001;  // '0'
                    currentHexadecimal = txbuf0;
                end
                2'b01: begin
                   display2 = 7'b1001111;  // '1'
                   currentHexadecimal = txbuf1;
                end
                2'b10: begin
                    display2 = 7'b0010010;  // '2'
                    currentHexadecimal = txbuf2;                    
                end
                2'b11: begin
                    display2 = 7'b0000110;  // '3'                    
                    currentHexadecimal = txbuf3;
                end
            endcase
        
        end else begin
            display3 = 7'b1111010; // display 3 is r
            case(rxIndex)
                 2'b00: begin
                    display2 = 7'b0000001;  // '0'
                    currentHexadecimal = rxbuf0;
                end
                2'b01: begin
                   display2 = 7'b1001111;  // '1'
                   currentHexadecimal = rxbuf1;
                end
                2'b10: begin
                    display2 = 7'b0010010;  // '2'
                    currentHexadecimal = rxbuf2;                    
                end
                2'b11: begin
                    display2 = 7'b0000110;  // '3'                    
                    currentHexadecimal = rxbuf3;
                end           
            endcase
        
        end
    end
    
    HexTo7Segment hexTo7Segment (
        .clk(clk),
        .currentHexadecimal(currentHexadecimal),
        .display1(display1),
        .display0(display0)
    );    
        
    reg [1:0] active_digit = 0;
    integer refresh_counter = 0;
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter == 25000) begin
            refresh_counter <= 0;
            active_digit <= active_digit + 1;
            if (active_digit == 3) active_digit <= 0;
        end
    end
    
    always @(*) begin
        case (active_digit)
            2'b00: begin seg <= display0; an <= 4'b1110; end
            2'b01: begin seg <= display1; an <= 4'b1101; end
            2'b10: begin seg <= display2; an <= 4'b1011; end
            2'b11: begin seg <= display3; an <= 4'b0111; end
        endcase
    end
    
endmodule
