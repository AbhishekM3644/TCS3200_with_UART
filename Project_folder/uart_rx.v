`timescale 1ns/1ps

module uart_rx1 (
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

    reg [2:0] state = IDLE;
    reg [2:0] bit_index = 0;
    reg [7:0] data_reg = 0;
    reg calc_parity = 0;
    reg rx_sampled;
    reg [7:0] cycle_count = 0;

    always @(posedge clk_3125) begin
        rx_sampled <= rx;
        rx_complete <= 1'b0;

        case (state)
            IDLE: begin
                bit_index <= 0;
                data_reg <= 0;
                calc_parity <= 0;
                rx_msg <= 0;
                rx_parity <= 0;
                cycle_count <= 0;
                if (rx_sampled == 1'b0 && cycle_count == CYCLES_PER_BIT - 1) state <= START;
                else cycle_count <= cycle_count + 1;
            end

            START: begin
                if (cycle_count == CYCLES_PER_BIT - 1) begin
                    if (rx_sampled == 1'b0) state <= DATA;
                    else state <= IDLE; // false start
                    cycle_count <= 0;
                end else cycle_count <= cycle_count + 1;
            end

            DATA: begin
                if (cycle_count == CYCLES_PER_BIT - 1) begin
                    data_reg <= {data_reg[6:0], rx_sampled};
                    calc_parity <= calc_parity ^ rx_sampled;
                    if (bit_index == 7) state <= PARITY;
                    else bit_index <= bit_index + 1;
                    cycle_count <= 0;
                end else cycle_count <= cycle_count + 1;
            end

            PARITY: begin
                if (cycle_count == CYCLES_PER_BIT - 1) begin
                    rx_parity <= rx_sampled;
                    rx_msg <= (rx_parity != calc_parity) ? 8'h3F : data_reg;
                    state <= STOP;
                    cycle_count <= 0;
                end else cycle_count <= cycle_count + 1;
            end

            STOP: begin
                if (cycle_count == CYCLES_PER_BIT - 1) begin
                    if (rx_sampled == 1'b1) rx_complete <= 1'b1;
                    state <= IDLE;
                    cycle_count <= 0;
                end else cycle_count <= cycle_count + 1;
            end
        endcase
    end

endmodule