`timescale 1ns / 1ps

module TXBUF
#(parameter DATA_WIDTH = 8, BAUD_RATE = 115200)
(
    input logic clk,
    input logic transmit_enable, // BTNC
    input logic load_enable, // BTND
    input logic auto_transmit_enable, // sw[15]
    input logic [DATA_WIDTH-1:0] sw,
    
    output logic [DATA_WIDTH-1:0] txbuf0,
    output logic [DATA_WIDTH-1:0] txbuf1,
    output logic [DATA_WIDTH-1:0] txbuf2,
    output logic [DATA_WIDTH-1:0] txbuf3,
    
    output logic [DATA_WIDTH-1:0] led,
    output logic tx_line
);

    logic slw_clk;
    baudClock clock(
        .clk(clk), 
        .slw_clk(slw_clk)
    );
    
    /*logic transmit_enableD, load_enableD;
    Debounce  transmitD(
        .clk(clk),
        .btn_in(transmit_enable),
        .btn_out(transmit_enableD)
    );
    Debounce loadD(
        .clk(clk),
        .btn_in(load_enable),
        .btn_out(load_enableD)
    );*/

    
    typedef enum logic[3:0] {
        IDLE,
        LOAD,
        SEND_START_BIT,
        SEND_DATA,
        SEND_PARITY,
        SEND_STOP_BIT,
        AUTO_SEND_NEXT
    } state_t;
    
    state_t state = IDLE;
    logic [DATA_WIDTH:0] tx_shift_reg;
    logic [3:0] bit_count = 0;
    logic parity_bit = 0;
    logic last_load_enable;
    logic last_transmit_enable;  
    logic [DATA_WIDTH-1:0] fifo[3:0];
    
    logic [2:0] fifo_index = 3'b100;
    logic last_auto_transmit_enable;
    
    
    always_ff @(posedge slw_clk) begin
        if (load_enable && !last_load_enable) begin
            fifo[3] <= fifo[2];
            fifo[2] <= fifo[1];
            fifo[1] <= fifo[0];
            fifo[0] <= sw;
            led <= sw; 
        end
        last_load_enable <= load_enable;
    end
    
    assign txbuf0 = fifo[0];
    assign txbuf1 = fifo[1];
    assign txbuf2 = fifo[2];
    assign txbuf3 = fifo[3];
    
    always_ff @(posedge slw_clk) begin
        case (state)
            IDLE: begin 
                if (transmit_enable && !last_transmit_enable) begin
                    if (auto_transmit_enable) begin
                        fifo_index = 0;
                        state = AUTO_SEND_NEXT;
                    end else begin
                        tx_shift_reg = {1'b0, fifo[3]};
                        parity_bit = ^fifo[3];
                        bit_count = 0;
                        state = SEND_START_BIT;
                    end
                end
                
            end
            AUTO_SEND_NEXT: begin
                if (fifo_index < 4) begin
                    tx_shift_reg <= {1'b0, fifo[fifo_index]};
                    parity_bit <= ^fifo[fifo_index];  
                    bit_count <= 0;
                    state <= SEND_START_BIT;
                end else begin
                    state <= IDLE;
                end
            end
            SEND_START_BIT: begin
                tx_line <= 0;
                state <= SEND_DATA;
            end
            SEND_DATA: begin
                if (bit_count < DATA_WIDTH) begin
                    tx_line <= tx_shift_reg[bit_count];
                    bit_count <= bit_count + 1;
                end else begin
                    state <= SEND_PARITY;
                end
            end
            SEND_PARITY: begin
                tx_line <= parity_bit;
                state <= SEND_STOP_BIT;
            end
            SEND_STOP_BIT: begin
                tx_line <= 1;
                if (auto_transmit_enable && (fifo_index < 3)) begin
                    fifo_index <= fifo_index + 1;
                    state <= AUTO_SEND_NEXT;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
        last_transmit_enable <= transmit_enable;
        last_auto_transmit_enable <= auto_transmit_enable;
    end

endmodule