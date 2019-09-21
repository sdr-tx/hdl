
module top_level (
    input   hwclk,
    // input   clk,
    input   rst,
    output  [7:0] leds,
    // output  pwm,

    // FT245 interface
    inout   [7:0] in_out_245,
        // input   [7:0] in_245,
        // output  [7:0] out_245,
        // output  tx_oe_245,
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

    // FT245 <---> SB_IO
    wire [7:0] in_245;
    wire [7:0] out_245;
    wire tx_oe_245;

    // FT245 - Simple Interface
    wire rx_rdy_si, rx_ack_si;
    wire tx_rdy_si, tx_ack_si;
    wire [7:0] rx_data_si, tx_data_si;

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

/*    modulator #(
        .FOO            (10),
        .AM_CLKS_IN_PWM_STEPS   (`AM_PWM_STEPS),
        .AM_PWM_STEPS           (`AM_PWM_STEPS)
    ) am_modulator (
        .clk    (clk),
        .rst    (rst),
        .pwm    (pwm)
    );*/

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
        .tx_rdy_si  (tx_rdy_si)
    );

    ft245_fifo_interface #(
        .CLOCK_PERIOD_NS (8)
    ) inst_ft245_fifo_interface (
        .clk            (clk),
        .rst            (rst),
        // ft245 rx interface
        .rx_data_245    (in_245),
        .rxf_245        (rxf_245),
        .rx_245         (rx_245),
        // ft245 tx interface
        .tx_data_245    (out_245),
        .txe_245        (txe_245),
        .wr_245         (wr_245),
        .tx_oe_245      (tx_oe_245),
        // simple interface
        .rx_data_si     (rx_data_si),
        .rx_rdy_si      (rx_rdy_si),
        .rx_ack_si      (rx_ack_si),
        .tx_data_si     (tx_data_si),
        .tx_rdy_si      (tx_rdy_si),
        .tx_ack_si      (tx_ack_si)
    );

    genvar h;
    generate
        for (h=0 ; h<8 ; h=h+1) begin
            SB_IO #(
                .PIN_TYPE(6'b101001),
                .PULLUP(1'b0)
            ) IO_PIN_INST (
                .PACKAGE_PIN (in_out_245[h]),
                .LATCH_INPUT_VALUE (),
                .CLOCK_ENABLE (),
                .INPUT_CLK (),
                .OUTPUT_CLK (),
                .OUTPUT_ENABLE (tx_oe_245),
                .D_OUT_0 (out_245[h]),
                .D_OUT_1 (),
                .D_IN_0 (in_245[h]),
                .D_IN_1 ()
            );
        end
    endgenerate

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

