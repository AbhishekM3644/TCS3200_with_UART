`timescale 1ns/1ps

module uart_rx (
    input wire clk_3125,
    input wire rx, 
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
);

    localparam IDLE   = 3'b000,
               START  = 3'b001,
               DATA   = 3'b010,
               PARITY = 3'b011,
               STOP   = 3'b100;
    
    localparam CYCLES_PER_BIT = 14; // Approx. for 230,400 bps with 3.125 MHz clock
    localparam MID_CYCLE = (CYCLES_PER_BIT / 2); // Sample in the middle of a bit

    reg [2:0] state = IDLE;
    reg [2:0] bit_index = 0;
    reg [7:0] data_reg = 0;
    reg calc_parity = 0;
    reg rx_sampled;
    reg [7:0] cycle_count = 0;

    always @(posedge clk_3125) begin
        rx_sampled <= rx;
        rx_complete <= 1'b0; // Default to low, will pulse high for one cycle

        case (state)
            IDLE: begin
                // Reset all values while waiting for a new frame
                bit_index <= 0;
                data_reg <= 0;
                calc_parity <= 0;
                rx_msg <= 0;
                rx_parity <= 0;
                
                // CORRECTED: Look for a start bit on any clock cycle
                if (rx_sampled == 1'b0) begin
                    cycle_count <= 0;
                    state <= START;
                end
            end

            START: begin
                // Wait for half a bit-period to sample in the middle of the start bit
                if (cycle_count == MID_CYCLE) begin
                    if (rx_sampled == 1'b0) begin // Confirm it's a valid start bit
                        state <= DATA;
                        cycle_count <= 0; // Reset counter for the first data bit
                    end else begin
                        state <= IDLE; // False start (glitch), return to idle
                    end
                end else begin
                    cycle_count <= cycle_count + 1;
                end
            end

            DATA: begin
                // Wait for a full bit-period to sample in the middle of the data bit
                if (cycle_count == CYCLES_PER_BIT -1) begin
                    cycle_count <= 0; // Reset for next bit
                    data_reg <= {rx_sampled, data_reg[7:1]}; // Shift in LSB-first
                    calc_parity <= calc_parity ^ rx_sampled;

                    if (bit_index == 7) begin
                        state <= PARITY;
                    end else begin
                        bit_index <= bit_index + 1;
                    end
                end else begin
                    cycle_count <= cycle_count + 1;
                end
            end

            PARITY: begin
                // Wait for a full bit-period to sample the parity bit
                if (cycle_count == CYCLES_PER_BIT-1 ) begin
                    cycle_count <= 0;
                    rx_parity <= rx_sampled;
                    // Assign final message based on parity check
                    rx_msg <= (rx_sampled != calc_parity) ? 8'h3F : data_reg;
                    state <= STOP;
                end else begin
                    cycle_count <= cycle_count + 1;
                end
            end

            STOP: begin
                // Wait for a full bit-period to sample the stop bit
                if (cycle_count == CYCLES_PER_BIT-1) begin
                    if (rx_sampled == 1'b1) begin // Check for valid stop bit
                        rx_complete <= 1'b1;
                    end
                    // Regardless of stop bit, return to IDLE for next frame
                    state <= IDLE;
                end else begin
                    cycle_count <= cycle_count + 1;
                end
            end
            
            default:
                state <= IDLE;

        endcase
    end

endmodule
