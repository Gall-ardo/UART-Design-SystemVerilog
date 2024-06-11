`timescale 1ns / 1ps

module RXBUF
#(parameter DATA_WIDTH = 8, BAUD_RATE  = 115200)
(
    input logic clk,
    input logic rx_line, // to receive data
    
    output logic error,
    output logic [DATA_WIDTH-1:0] led, // left 8 digit
    output logic [DATA_WIDTH-1:0] rxbuf3, 
    output logic [DATA_WIDTH-1:0] rxbuf2,
    output logic [DATA_WIDTH-1:0] rxbuf1, 
    output logic [DATA_WIDTH-1:0] rxbuf0,
    output logic done
    );
    
    logic slw_clk;
    baudClock clock(
    .clk(clk), 
    .slw_clk(slw_clk)
    );
    
    typedef enum logic[2:0] {
        IDLE,
        WAIT_FOR_START,
        RECEIVE_DATA,
        CHECK_PARITY,
        PROCESS_DATA
    } state_t;

    state_t state = IDLE;
    logic [DATA_WIDTH:0] rx_shift_reg = 0;
    logic [3:0] bit_count =  4'b0000;
    logic calculated_parity = 0;

    always_ff @(posedge slw_clk) begin
        case (state)
            IDLE: begin
                if (rx_line == 1)
                    state <= WAIT_FOR_START;
            end
            WAIT_FOR_START: begin
                if (rx_line == 0) begin // Start bit
                    state <= RECEIVE_DATA;
                    bit_count <= 0;
                end
            end
            RECEIVE_DATA: begin
                if (bit_count < DATA_WIDTH) begin
                    rx_shift_reg[bit_count] <= rx_line;
                    bit_count <= bit_count + 1;
                end else begin
                    state <= CHECK_PARITY;
                end
            end
            CHECK_PARITY: begin
                rx_shift_reg[DATA_WIDTH] <= rx_line;
                state <= PROCESS_DATA;
            end
            PROCESS_DATA: begin
                calculated_parity = ^rx_shift_reg[DATA_WIDTH-1:0];
                if (calculated_parity != rx_shift_reg[DATA_WIDTH]) begin 
                    error <= 1;
                    done <= 1;
                    led <= 8'b00000000; // error maybe? dont know how to show
                end else begin
                    error <= 0;
                    done <= 1;
                    rxbuf3 <= rxbuf2;
                    rxbuf2 <= rxbuf1;
                    rxbuf1 <= rxbuf0;
                    rxbuf0 <= rx_shift_reg[DATA_WIDTH-1:0];
                    led <= rx_shift_reg[DATA_WIDTH-1:0];
                end
                state <= IDLE;
            end
        endcase
    end

endmodule
