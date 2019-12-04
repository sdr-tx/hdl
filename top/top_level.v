`include "../inc/module_params.v"

module top_level (
    input   hwclk,
    input   rst,
    output  [7:0] leds,
    output  pwm,
    output  pwm_diff_p,
    output  pwm_diff_n,
    output  pwm_pin,
//    output read,
    output fifo_empty,
//    output fifo_full,

    // FT245 interface
    inout   [7:0] in_out_245,
    input   rxf_245,
    output  rx_245,
    input   txe_245,
    output  wr_245,

    // --- test ---
    output  symb_clk
//    output  tc_pwm_step,
//    output  tc_pwm_symb,
//    output  fake_rst,
//    output  test_baudrate
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
    wire rx_valid_si, rx_ready_si;
    wire tx_valid_si, tx_ready_si;
    wire [7:0] rx_data_si, tx_data_si;

    // Inteface between fifo and modulator
    wire [7:0] sample;
    wire read_sample;

    // Inteface between control_unit and deco_unit
    wire tx, rx;
    wire [7:0] data_tx, data_rx;

    // Inteface between deco_unit and modulator
    wire new_sample;

    // test
    reg [26:0] count;
    wire pwm_signal;
    assign read = read_sample;

    /***************************************************************************
     * assignments
     ***************************************************************************
     */
    assign leds = led_reg;
    assign pwm = pwm_signal;
    assign pwm_diff_p = pwm_signal;
    assign pwm_diff_n = ~pwm_signal;
    assign pwm_pin = pwm_signal;

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
        // simple interface - RX
        .rx_data_si (rx_data_si),
        .rx_valid_si(rx_valid_si),
        .rx_ready_si(!fifo_full),
        // simple interface - TX
        .tx_data_si (),
        .tx_valid_si(),
        .tx_ready_si()
    );

    fifo #(
        .DEPTH_WIDTH    (10),
        .DATA_WIDTH     (8)
    ) data_fifo (
        .clk        (clk),
        .rst        (rst),
        /* write port */
        .wr_data_i  (rx_data_si),
        .wr_en_i    (rx_valid_si & !fifo_full),
        /* read port */
        .rd_data_o  (sample),
        .rd_en_i    (read_sample),
        /* control signal */
        .full_o     (fifo_full),
        .empty_o    (fifo_empty)
        );

    modulator #(
        .PARAMETER01    (`PARAMETER01),
        .PARAMETER02    (`PARAMETER02),
        .PARAMETER03    (`PARAMETER03)
        // .AM_CLKS_PER_PWM_STEP   ('d1),
        // .AM_PWM_STEP_PER_SAMPLE ('d63),
        // .AM_BITS_PER_SAMPLE     ('d8)
<<<<<<< HEAD
        // .PSK_CLKS_PER_BIT       ('d1),
        // .PSK_BITS_PER_SYMBOL    ('d4)
=======

        .PSK_CLKS_PER_BIT       ('d4),
        .PSK_BITS_PER_SYMBOL    ('d8)
>>>>>>> mercurial-board
    ) top_modulator (
        .clk    (clk),
        .rst    (rst),
        .enable (1'b1),
        /* FIFO interface */
        .sample (sample),
        .empty  (fifo_empty),
        .read   (read_sample),
        /* data flow */
<<<<<<< HEAD
        .pwm    (pwm)//,
=======
        .pwm    (pwm_signal),

        .symb_clk(symb_clk)
>>>>>>> mercurial-board
        // .tc_pwm_step(tc_pwm_step),
        // .tc_pwm_symb(tc_pwm_symb)
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

