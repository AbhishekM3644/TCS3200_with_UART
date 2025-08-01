`timescale 1ns/1ps

module topmodule_tb;

reg clk_3125;
wire tx, rx_complete;
wire [7:0] rx_msg;
reg clk_1MHz, cs_out;

wire [1:0] filter;
reg [1:0] exp_filter;

wire [1:0] color;
reg [1:0] exp_color;

integer error_count;
reg [2:0] i, j;
integer fw;
integer tp, k, l, m, counter;

reg tx_start_reg;
assign tx_start = tx_start_reg; // If you change the top module, wire this properly

top_module abc (
    .clk_1MHz(clk_1MHz),       
    .clk_3125(clk_3125),       
    .cs_out(cs_out),         
    .tx(tx),   
     .filter(filter),       
        .color(color),         
    .rx_msg(rx_msg),  
    .rx_complete(rx_complete)
);

initial begin
    clk_1MHz = 0; clk_3125 = 0; exp_filter = 2; fw = 0;
    exp_color = 0; error_count = 0; i = 0;
    cs_out = 1; tp = 0; k = 0; j = 0; l = 0; m = 0;
    tx_start_reg = 0;
    #10000000;
    $finish;
end

// Clock for TCS3200
always #500 clk_1MHz = ~clk_1MHz;

// Clock for UART
always #160000 clk_3125 = ~clk_3125;  // ~3125Hz

// Expected color & filter generation
always @(posedge clk_1MHz) begin
    m = (i % 3) + 1;
    exp_filter = 3; #500000;
    exp_filter = 0; #500000;
    exp_filter = 1; #500000;
    exp_filter = 2; exp_color = (i % 3) + 1;
    i = i + 1; m = m + 1; #1000;

    // Trigger UART tx_start once per color update
    tx_start_reg = 1;  // Pulse high
              // 1 UART cycle
    tx_start_reg = 0;
end

// Simulate TCS3200 cs_out pulsing
always begin
    for (j = 0; j < 6; j = j + 1) begin
        #1000;
        for (l = 0; l < 3; l = l + 1) begin
            case (exp_filter)
                0: tp = (m == 1) ? 10 : 16;
                1: tp = (m == 3) ? 8  : 18;
                3: tp = (m == 2) ? 12 : 19;
                default: tp = 17;
            endcase

            counter = 500000 / (2 * tp);
            for (k = 0; k < counter; k = k + 1) begin
                cs_out = 1; #tp;
                cs_out = 0; #tp;
            end
            #(500000 - (counter * 2 * tp));
        end
        #1000;
    end
end

// Error checking
always @(clk_1MHz) begin
    #1;
    if (filter !== exp_filter) error_count = error_count + 1;
    if (color !== exp_color) error_count = error_count + 1;

    if (i == 6) begin
        if (error_count !== 0) begin
            fw = $fopen("results.txt", "w");
            $fdisplay(fw, "%02h", "Errors");
            $display(" Error(s) encountered, please check your design!");
            $fclose(fw);
        end else begin
            fw = $fopen("results.txt", "w");
            $fdisplay(fw, "%02h", "No Errors");
            $display(" No errors encountered, congratulations!");
            $fclose(fw);
        end
        i = 0;
    end
end



endmodule