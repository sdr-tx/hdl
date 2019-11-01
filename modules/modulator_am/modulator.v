`timescale 1ns/1ps
`include "../../inc/project_defines.v"

module modulator_foo #(
    parameter FOO = 'd10,
    parameter AM_CLKS_PER_PWM_STEP = 'd1,
    parameter AM_PWM_STEP_PER_SAMPLE = 'd255,
    parameter AM_BITS_PER_SAMPLE = 'd8
)(
    input clk,
    input rst,
    input enable,
    /* FIFO interface */
    input [7:0] sample,
    input empty,
    output reg read,
    /* data flow */
    output reg pwm,

    output tc_pwm_step,
    output tc_pwm_symb
);
    localparam WIDTH = $clog2(FOO);
    localparam ST_IDLE=0;
    localparam ST_RUNNING=1;


    /* registers */
    reg  state;
    // wire tc_pwm_step, tc_pwm_symb;
    reg [7:0] counter_duty;
    wire counter_rst;
    reg counter_start;
    reg [7:0] sample_reg;

    assign counter_rst = counter_start | rst;

    // counter to generate ticks at pwm-steps frequency
    module_counter #(
        .WIDTH  (8)
    ) inst_counter_pwm_steps (
        .clk        (clk),
        .rst        (counter_rst),
        .enable     (1'b1),
        .max_count  (AM_CLKS_PER_PWM_STEP),
        .tc         (tc_pwm_step)
    );

    // counter to generate ticks at pwm-symbols frequency
    module_counter #(
        .WIDTH  (8)
    ) inst_counter_pwm_symb (
        .clk        (clk),
        .rst        (counter_rst),
        .enable     (1'b1),
        .max_count  (127),
        .tc         (tc_pwm_symb)
    );

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        counter_start <= 1'b0;
        read <= 1'b0;
        
        if (rst == 1'b1) begin
            counter_duty <= 0;
            state <= ST_IDLE;
            sample_reg <= 'd0;
            pwm <= 1'b0;
            counter_duty <= 'd0;
        end else if (enable == 1'b1) begin
            case (state)
                ST_IDLE:
                begin
                    if (empty == 1'b0) begin
                        read <= 1'b1;
                        counter_start <= 1'b1;
                        state <= ST_RUNNING;
                        sample_reg <= sample;
                        counter_duty <= 'd0;
                    end
                end

                ST_RUNNING:
                begin
                    if (tc_pwm_step == 1'b1) begin
                        if(counter_duty < sample_reg)
                            pwm <= 1'b1;
                        else begin
                            pwm <= 1'b0;
                        end
                        counter_duty <= counter_duty + 1;
                    end
                    if (tc_pwm_symb == 1'b1) begin
                        state <= ST_IDLE;
                    end
                end

                default:
                begin
                    state <= ST_IDLE;
                end
            endcase
        end
    end

  initial begin
      $dumpfile ("waveform.vcd");
      $dumpvars (0, modulator);
  end
endmodule

