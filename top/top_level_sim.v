
module top_level (
    input   clk,
    input   rst,
    output  [7:0] leds,
    // output  pwm,

    // FT245 interface
    input   [7:0] rx_data_245,
    input   rxf_245,
    output  rx_245,
    output  [7:0] tx_data_245,
    input   txe_245,
    output  wr_245,
    output  tx_oe_245,

    // --- test ---
    output  fake_rst
);
    /***************************************************************************
     * test
     ***************************************************************************
     */
    assign fake_rst = 1'b1;

    /***************************************************************************
     * signals
     ***************************************************************************
     */
    // reg clk;
    reg [7:0] led_reg;

    // FT245 - Simple Interface
    wire rx_rdy_si, rx_ack_si;
    wire tx_rdy_si, tx_ack_si;
    wire [7:0] rx_data_si, tx_data_si;

    // Inteface between control_unit and deco_unit
    wire tx, rx;
    wire [7:0] data_tx, data_rx, sample;

    // test
    reg [26:0] count;


    /***************************************************************************
     * assignments
     ***************************************************************************
     */
    assign leds = led_reg;


    /***************************************************************************
     * module instances
     ***************************************************************************
     */
    // /* pll */
    // pll_128MHz system_clk(
    //     .clock_in   (hwclk),
    //     .clock_out  (clk),
    //     .locked     (aux)
    // );

    /* FT245 wrapper
     * Interface between FT245 FIFO and SIMPLE INTERFACE
     */
    ft245_fifo_interface #(
        .CLOCK_PERIOD_NS(10)
    ) inst_ft245_fifo_interface (
        .clk        (clk),
        .rst        (rst),
        // FT245 interface
        .rx_data_245 (rx_data_245),
        .rxf_245    (rxf_245),
        .rx_245     (rx_245),
        .tx_data_245(tx_data_245),
        .txe_245    (txe_245),
        .wr_245     (wr_245),
        .tx_oe_245  (tx_oe_245),
        // simple interface
        .rx_data_si (rx_data_si),
        .rx_rdy_si  (rx_rdy_si),
        .rx_ack_si  (rx_ack_si),
        .tx_data_si (tx_data_si),
        .tx_rdy_si  (tx_rdy_si),
        .tx_ack_si  (tx_ack_si)
    );

    controller #(
        .FOO        (10)
    ) control_unit (
        .clk        (clk),
        .rst        (rst),
        // fifo simple interface
        .rx_data_si (rx_data_si),
        .rx_rdy_si  (rx_rdy_si),
        .rx_ack_si  (rx_ack_si),
        .tx_ack_si  (tx_ack_si),
        .tx_data_si (tx_data_si),
        .tx_rdy_si  (tx_rdy_si),
        // communication with decoder
        .tx         (tx),
        .data_tx    (data_tx),
        .rx         (rx),
        .data_rx    (data_rx)
    );

    decoder deco_unit (
        .clk        (clk),
        .rst        (rst),
        .data_rx    (data_rx),
        .rx         (rx),
        .data_tx    (data_tx),
        .tx         (tx),
        .sample     (sample)
    );

    // modulator #(
    //     .FOO            (10),
    //     .AM_CLKS_IN_PWM_STEPS   (`AM_PWM_STEPS),
    //     .AM_PWM_STEPS           (`AM_PWM_STEPS)
    // ) am_modulator (
    //     .clk    (clk),
    //     .rst    (rst),
    //     .pwm    (pwm)
    // );

    /* Led keep alive */
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            led_reg = 8'hFF;
            count = 27'd0;
        end else if (count == 27'd126000000) begin
            led_reg = led_reg + 1;
            count = 27'd0;
        end else begin
            count = count + 1;
        end
    end

endmodule

