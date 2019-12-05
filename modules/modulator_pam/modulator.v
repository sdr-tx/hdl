`timescale 1ns/1ps
//`include "../../inc/project_defines.v"

module modulator #(
    parameter PARAMETER01 = 4,  // PAM_CLKS_SAMPLING_FREQ
    parameter PARAMETER02 = 100,// PAM_CLKS_PER_BCLK        - rate 1 : 100 MHz
    parameter PARAMETER03 = 4   // PAM_DATA_LENGHT
)(
    input clk,
    input rst,
    input enable,
    /* FIFO interface */
    input [7:0] sample,
    input empty,
    output reg read,
    /* data flow */
    output nsync,
    output bclk,
    output pwm, // sdata

    // test
    output reg symb_clk
);
    // real PAM modulator parameters
    localparam PAM_CLKS_SAMPLING_FREQ   = PARAMETER01;
    localparam PAM_CLKS_PER_BCLK        = PARAMETER02;
    localparam PAM_DATA_LENGHT          = PARAMETER03;

    localparam WIDTH_COUNT_FS   = $clog2(PAM_CLKS_SAMPLING_FREQ);
    localparam WIDTH_COUNT_BCLK = $clog2(PAM_CLKS_PER_BCLK);
    localparam WIDTH_COUNT_BITS = $clog2(PAM_DATA_LENGHT);

    localparam ST_IDLE = 0;
    localparam ST_SENDING = 1;

    /* registers */
    reg  state;
    reg [WIDTH_COUNT_FS-1:0] counter_fs;
    reg [WIDTH_COUNT_BCLK-1:0] counter_bclk;
    reg [WIDTH_COUNT_BITS-1:0] counter_bits;
    reg [23:0] sample_reg;
    reg [1:0] sample_byte;

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        read <= 1'b0;
        nsync <= 1'b1;

        if (rst == 1'b1) begin
            counter_fs <= 'd0;
            counter_bclk <= 0;
            counter_bits <= 0;
            state <= ST_IDLE;
            sample_reg <= 'd0;
            sample_byte <= 'd0;
        end else if (enable == 1'b1) begin
            counter_fs <= counter_fs + 1;
            case (state)
                ST_IDLE:
                begin
                    if (counter_fs == PAM_CLKS_SAMPLING_FREQ-1) begin
                        counter_fs <= 0;

                        if (empty == 1'b0) begin
                            state <= ST_RUNNING;
                            counter_bits <= 0;
                            counter_clks <= 0;
                            read <= 1'b1;
                            sample_reg [23:16] <= sample;
                            sample_byte <= sample_byte + 1;
                        end
                    end
                end

                ST_RUNNING:
                begin
                    nsync <= 0;
                    if (empty == 1'b0) begin
                        if (sample_byte == 2'd1) begin
                            sample_reg [15:8] <= sample;
                            sample_byte <= sample_byte + 1;
                        end else if (sample_byte == 2'd2) begin
                            sample_reg [7:0] <= sample;
                            sample_byte <= sample_byte + 1;
                        end
                    end

                    if (counter_bclk == PAM_CLKS_PER_BCLK/2) begin
                        bclk <= 0;
                    end else if (counter_bclk == PAM_CLKS_PER_BCLK-1) begin
                        bclk <= 1;
                        sample_reg <= sample_reg >> 1;
                        counter_bits <= counter_bits + 1;
                        counter_bclk <= 0;
                    end else begin
                        counter_bclk <= counter_bclk + 1;
                    end

                    if ((counter_bits == PAM_DATA_LENGHT-1) &&
                        (counter_clks == PAM_CLKS_PER_BCLK-1)) begin
                        state <= ST_IDLE;
//                        symb_clk <= ~symb_clk;
                    end
                end

                default:
                begin
                    state <= ST_IDLE;
                end
            endcase
        end
    end

    assign sdata = sample_reg[0];

    initial begin
        $dumpfile ("waveform.vcd");
        $dumpvars (0, modulator);
    end
endmodule

