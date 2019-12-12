`timescale 1ns/1ps

module modulator #(
    parameter PARAMETER01 = 4,  // PSK_CLKS_PER_BIT
    parameter PARAMETER02 = 4,  // PSK_BITS_PER_SYMBOL
    parameter PARAMETER03 = 0,
    parameter PARAMETER04 = 30  // PSK_REPEATED_SAMPLE
)(
    input clk,
    input rst,
    input enable,
    /* FIFO interface */
    input [7:0] sample,
    input empty,
    output reg read,
    /* data flow */
    output pwm,
    output sdata,
    output bclk,
    output nsync,

    // test
    output reg symb_clk
);
    // real psk modulator parameters
    localparam PSK_CLKS_PER_BIT     = PARAMETER01;
    localparam PSK_BITS_PER_SYMBOL  = PARAMETER02;
    localparam PSK_REPEATED_SAMPLE  = PARAMETER04;

    localparam WIDTH_COUNT_CLKS         = $clog2(PSK_CLKS_PER_BIT);
    localparam WIDTH_COUNT_BITS         = $clog2(PSK_BITS_PER_SYMBOL);
    localparam WIDTH_REPEATED_SAMPLE    = $clog2(PSK_REPEATED_SAMPLE);

    localparam ST_IDLE = 0;
    localparam ST_RUNNING = 1;

    /* registers */
    reg  state;

    reg [WIDTH_COUNT_CLKS-1:0] counter_clks;
    reg [WIDTH_COUNT_BITS-1:0] counter_bits;
    reg [WIDTH_REPEATED_SAMPLE-1:0] repeated_sample;
    
    reg [7:0] sample_reg;
    reg [7:0] shift_register;

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        read <= 1'b0;
        
        if (rst == 1'b1) begin
            symb_clk <= 0;
            sample_reg <= 'd0;
            shift_register <= 0;
            counter_bits <= 0;
            counter_clks <= 0;
            repeated_sample <= 0;
            state <= ST_IDLE;
        end else if (enable == 1'b1) begin
            case (state)
                ST_IDLE:
                begin
                    if (empty == 1'b0) begin
                        read <= 1'b1;
                        shift_register <= sample;
                        sample_reg <= sample;
                        counter_bits <= 0;
                        counter_clks <= 0;
                        repeated_sample <= 0;
                        state <= ST_RUNNING;
                    end
                end

                ST_RUNNING:
                begin
                    if (counter_clks == PSK_CLKS_PER_BIT-1) begin
                        shift_register <= shift_register >> 1;
                        counter_bits <= counter_bits + 1;
                        counter_clks <= 0;
                    end else begin
                        counter_clks <= counter_clks + 1;
                    end

                    if ((counter_bits == PSK_BITS_PER_SYMBOL-1) &&
                        (counter_clks == PSK_CLKS_PER_BIT-1)) begin
                        repeated_sample <= repeated_sample + 1;
                        counter_bits <= 0;
                        counter_clks <= 0;
                        shift_register <= sample_reg;

                        if (repeated_sample == PSK_REPEATED_SAMPLE-1) begin
                            symb_clk <= ~symb_clk;
                            repeated_sample <= 0;
                            read <= 1'b1;
                            sample_reg <= sample;
                            shift_register <= sample;

                            if (empty == 1) begin
                                state <= ST_IDLE;
                            end
                        end
                    end
                end

                default:
                begin
                    state <= ST_IDLE;
                end
            endcase
        end
    end

    assign pwm = shift_register[0];

    initial begin
        $dumpfile ("waveform.vcd");
        $dumpvars (0, modulator);
    end
endmodule

