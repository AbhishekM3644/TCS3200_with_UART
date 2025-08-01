`timescale 1ns / 1ps

module uart_tx (
    input clk_3125,           
    input parity_type,         
    input tx_start,            
    input [7:0] data,          
    output reg tx,    
    output reg tx_done       
);

    reg [3:0] bit_cnt = 0;
    reg [9:0] shift_reg = 10'b1111111111;
    reg transmitting = 0;

    function parity_bit;
        input [7:0] data;
        input parity_type;
        begin
            parity_bit = parity_type ^ (^data);
        end
    endfunction

    always @(posedge clk_3125) begin
        if (!transmitting && tx_start) begin
           
            shift_reg <= {1'b1, parity_bit(data, parity_type), data, 1'b0}; // LSB first
            transmitting <= 1;
            bit_cnt <= 0;
            tx_done <= 0;
        end

        if (transmitting) begin
            tx <= shift_reg[0];
            shift_reg <= {1'b1, shift_reg[9:1]}; // Shift right
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 10) begin
                transmitting <= 0;
                tx_done <= 1;
                tx <= 1'b1; // Idle state
            end
        end else begin
            tx <= 1'b1; // Default high when idle
            tx_done <= 0;
        end
    end
endmodule
