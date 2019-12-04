`timescale 1ns/1ps
//`include "../../inc/project_defines.v"

module modulator #(
<<<<<<< HEAD
    parameter PARAMETER01 = 4,  // PSK_CLKS_PER_BIT
    parameter PARAMETER02 = 4,  // PSK_BITS_PER_SYMBOL
    parameter PARAMETER03 = 0
=======
    parameter FOO = 'd10,
    parameter PSK_CLKS_PER_BIT = 100,
    parameter PSK_BITS_PER_SYMBOL = 4
>>>>>>> mercurial-board
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

    // test
    output reg symb_clk
);
    // real psk modulator parameters
    localparam PSK_CLKS_PER_BIT     = PARAMETER01;
    localparam PSK_BITS_PER_SYMBOL  = PARAMETER02;

    localparam WIDTH_COUNT_CLKS = $clog2(PSK_CLKS_PER_BIT);
    localparam WIDTH_COUNT_BITS = $clog2(PSK_BITS_PER_SYMBOL);
    localparam ST_IDLE = 0;
    localparam ST_RUNNING = 1;


    /* registers */
    reg  state;
    reg [WIDTH_COUNT_CLKS-1:0] counter_clks;
    reg [WIDTH_COUNT_BITS-1:0] counter_bits;
    reg [7:0] sample_reg;

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        read <= 1'b0;
        
        if (rst == 1'b1) begin
            counter_bits <= 0;
            counter_clks <= 0;
            state <= ST_IDLE;
            sample_reg <= 'd0;
            symb_clk <= 0;
        end else if (enable == 1'b1) begin
            case (state)
                ST_IDLE:
                begin
                    if (empty == 1'b0) begin
                        read <= 1'b1;
                        counter_bits <= 0;
                        counter_clks <= 0;
                        state <= ST_RUNNING;
                        sample_reg <= sample;
                    end
                end

                ST_RUNNING:
                begin
                    if (counter_clks == PSK_CLKS_PER_BIT-1) begin
                        sample_reg <= sample_reg >> 1;
                        counter_bits <= counter_bits + 1;
                        counter_clks <= 0;
                    end else begin
                        counter_clks <= counter_clks + 1;
                    end
                    if ((counter_bits == PSK_BITS_PER_SYMBOL-1) &&
                        (counter_clks == PSK_CLKS_PER_BIT-1)) begin
                        if (empty == 0) begin
                            read <= 1'b1;
                            counter_bits <= 0;
                            counter_clks <= 0;
                            sample_reg <= sample;
                            symb_clk <= ~symb_clk;
                        end else begin
                            state <= ST_IDLE;
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

    assign pwm = sample_reg[0];

    initial begin
        $dumpfile ("waveform.vcd");
        $dumpvars (0, modulator);
    end
endmodule

