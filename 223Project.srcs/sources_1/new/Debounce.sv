`timescale 1ns / 1ps
module Debounce(
    input logic clk,
    input logic btn_in,
    output logic btn_out
);
    parameter DEBOUNCE_LIMIT = 21234;
    integer counter = 0;
    
    typedef enum logic [1:0] {IDLE, DEBOUNCE, WAIT} stateType;
        stateType [1:0] state = IDLE;
   
    always_ff @(posedge clk) begin
       case (state)
        IDLE: begin
            btn_out <= 0;
            if(btn_in) begin
                state <= DEBOUNCE;
            end
            else if (!btn_in) begin
                state <= IDLE;
            end
        end  
        
        DEBOUNCE: begin
        counter <= counter+1;
        if(counter >= DEBOUNCE_LIMIT)begin 
            counter <= 0;
            btn_out <= 1;
            state <= WAIT;
        end 
        end
        
        WAIT: begin
            btn_out <= 0;
            if(btn_in) begin
                btn_out <= 0;
            end
            else begin
                state <= IDLE;
            end
        end   
        endcase

    end 
endmodule