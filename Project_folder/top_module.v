`timescale 1ns / 1ps

module top_module (
       
    input clk_1MHz,       // for TCS3200
    input clk_3125,       // for UART modules
    input cs_out,         // from color sensor (frequency output)
    output tx, 
    output [1:0] filter, 
    output [1:0] color,      // UART TX line (optional: connect to external)
    output [7:0] rx_msg,  // Final received 8-bit message
    output rx_complete    // Signal when receive is done
);

    // Internal wires
    
  
    wire tx_done;
    wire tx_start;
    wire [7:0] data_to_send;

    // Assigning color_code to 8-bit data to send
     // pad remaining bits with 0
     // For now, always transmitting (can be modified for FSM)

    t1b_cd_fd tcs_module (
        .clk_1MHz(clk_1MHz),
        .cs_out(cs_out),
        .filter(filter),       
        .color(color)
    );
     assign data_to_send = {6'b000000, color};

    uart_tx tx_module (
        .clk_3125(clk_3125),
        .parity_type(1'b0),         // 0 = even parity
        .tx_start(tx_start),
        .data(data_to_send),
        .tx(tx),
        .tx_done(tx_done)
    );

    uart_rx1 rx_module (
        .clk_3125(clk_3125),
        .rx(tx),                    // Loopback connection
        .rx_msg(rx_msg),
        .rx_parity(rx_parity),
        .rx_complete(rx_complete)
    );

endmodule