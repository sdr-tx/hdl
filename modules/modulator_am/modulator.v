`timescale 1ns/1ps
// `include "../../inc/project_defines.v"

module modulator #(
    parameter PARAMETER01 = 1,      // AM_CLKS_PER_PWM_STEP     - 256M
    parameter PARAMETER02 = 255,    // AM_PWM_STEP_PER_SAMPLE   - 256M
    parameter PARAMETER03 = 8       // AM_BITS_PER_SAMPLE
)(
    input clk,
    input rst,
    input enable,
    /* FIFO interface */
    input [7:0] sample,
    input empty,
    output reg read,
    /* data flow */
    output reg nsync,
    output reg bclk,
    output pwm,

    // test
    output reg symb_clk
);
    // real AM modulator parameters
    localparam AM_CLKS_PER_PWM_STEP     = PARAMETER01; // 1000
    localparam AM_PWM_STEP_PER_SAMPLE   = PARAMETER02; // 255
    localparam AM_BITS_PER_SAMPLE       = PARAMETER03; // 8

    localparam WIDTH_COUNT_CLKS_PWM_STEP= $clog2(AM_CLKS_PER_PWM_STEP);

    localparam ST_IDLE=0;
    localparam ST_RUNNING=1;

    /* registers */
    reg state;
    reg fifowasempty;

    // counter to generate ticks at pwm-symbols frequency
    reg [AM_BITS_PER_SAMPLE:0] counter_steps;
    // counter to generate ticks at pwm-steps frequency
    reg [WIDTH_COUNT_CLKS_PWM_STEP-1:0] counter_clks_per_step;
    reg [7:0] sample_reg;
    reg [6:0] repeated_sample;

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        read <= 1'b0;
        if (rst == 1'b1) begin
            state <= ST_IDLE;
            sample_reg <= 'd0;
            counter_clks_per_step <= 'd0;
            counter_steps <= 'd0;
            symb_clk <= 0;
            repeated_sample <= 'd0;
        end else if (enable == 1'b1) begin
            case (state)
                ST_IDLE:
                begin
                    // symb_clk <= 0;
                    if (empty == 0) begin
                        counter_steps <= 'd0;
                        counter_clks_per_step <= 'd0;
                        state <= ST_RUNNING;
                        repeated_sample <= 'd0;
                    end
                end

                ST_RUNNING:
                begin
                    // symb_clk <= 1;
                    if (counter_clks_per_step == AM_CLKS_PER_PWM_STEP-1) begin
                        counter_clks_per_step <= 'd0;
                        counter_steps <= counter_steps + 1;
                    end else begin
                        counter_clks_per_step <= counter_clks_per_step + 1;
                    end


                    if ((counter_steps == AM_PWM_STEP_PER_SAMPLE-2) &&
                        (counter_clks_per_step == AM_CLKS_PER_PWM_STEP-1)) begin
                        // prepare to read a new sample
                        if ((empty == 0) &&
                            (repeated_sample == 7'd28)) begin
                            read <= 1;
                            fifowasempty <= 0;
                        end else begin
                            fifowasempty <= 1;
                        end
                    end

                    if ((counter_steps == AM_PWM_STEP_PER_SAMPLE-1) &&
                        (counter_clks_per_step == AM_CLKS_PER_PWM_STEP-1)) begin
/*                        if (empty == 1) begin
                            state <= ST_IDLE;
                        end*/
                    end

                    if ((counter_steps == AM_PWM_STEP_PER_SAMPLE) &&
                        (counter_clks_per_step == AM_CLKS_PER_PWM_STEP-1)) begin
                        repeated_sample <= repeated_sample + 1;
                        counter_steps <= 'd0;
                        symb_clk <= ~symb_clk;
                        if (repeated_sample == 7'd28) begin
                            repeated_sample <= 'd0;
                            if (fifowasempty == 0) begin
                                sample_reg <= sample;
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

    assign pwm = (counter_steps[7:0] < sample_reg) ? 1 : 0;

    initial begin
        $dumpfile ("waveform.vcd");
        $dumpvars (0, modulator);
    end
endmodule

