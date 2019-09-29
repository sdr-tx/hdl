
module top_level (
    input   hwclk,
    input   rst,
    output  [7:0] leds,
    output  pwm,

    // FT245 interface
    inout   [7:0] in_out_245,
    input   rxf_245,
    output  rx_245,
    input   txe_245,
    output  wr_245,

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
    reg clk;
    reg [7:0] led_reg;

    // FT245 - Simple Interface
    wire rx_rdy_si, rx_ack_si;
    wire tx_rdy_si, tx_ack_si;
    wire [7:0] rx_data_si, tx_data_si;

    // Inteface between control_unit and deco_unit
    wire tx, rx;
    wire [7:0] data_tx, data_rx;

    // Inteface between deco_unit and modulator
    wire new_sample;
    wire [7:0] sample;

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
    /* pll */
    pll_128MHz system_clk(
        .clock_in   (hwclk),
        .clock_out  (clk),
        .locked     (aux)
    );

    /* FT245 wrapper
     * Interface between FT245 FIFO and SIMPLE INTERFACE
     */
    ft245_block ft245_wrapper (
        .clk        (clk),
        .rst        (rst),
        // FT245 interface
        .in_out_245 (in_out_245),
        .rxf_245    (rxf_245),
        .rx_245     (rx_245),
        .txe_245    (txe_245),
        .wr_245     (wr_245),
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
        .sample     (sample),
        .new_sample (new_sample)
    );

    modulator #(
        .FOO            (10),
        .AM_CLKS_IN_PWM_STEPS   (`AM_PWM_STEPS),
        .AM_PWM_STEPS           (`AM_PWM_STEPS)
    ) am_modulator (
        .clk    (clk),
        .rst    (rst),
        .enable (1'b1),
        /* configuration parameters */
        .bits_per_sample    (8'd8),
        .clks_per_pwm_step  (8'd2),
        .new_sample         (new_sample),
        /* data flow */
        .sample (sample),
        .pwm    (pwm)
    );

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

