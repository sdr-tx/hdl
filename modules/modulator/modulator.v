`include "../../inc/project_defines.v"

module modulator #(
    parameter FOO = 10,
    parameter AM_CLKS_PER_PWM_STEP = 1,
    parameter AM_PWM_STEP_PER_SAMPLE = 256,
    parameter AM_BITS_PER_SAMPLE = 8
)(
    input clk,
    input rst,
    input enable,
    /* FIFO interface */
    input [7:0] sample,
    input empty,
    output read,
    /* data flow */
    output reg pwm
);
    localparam WIDTH = $clog2(FOO);

    /* registers */
    wire tc_pwm_step, tc_pwm_symb;
    reg [7:0] counter_duty;
    wire counter_rst, counter_start;

    assign counter_rst = counter_start | rst;

    // counter to generate ticks at pwm-steps frequency
    module_counter #(
        .WIDTH  (2)
    ) inst_counter_pwm_steps (
        .clk        (clk),
        .rst        (counter_rst),
        .enable     (1'b1),
        .max_count  (AM_CLKS_PER_PWM_STEP),
        .tc         (tc_pwm_step)
    );

    // counter to generate ticks at pwm-symbols frequency
    module_counter #(
        .WIDTH  (AM_BITS_PER_SAMPLE)
    ) inst_counter_pwm_symb (
        .clk        (clk),
        .rst        (counter_rst),
        .enable     (tc_pwm_step),
        .max_count  (AM_PWM_STEP_PER_SAMPLE),
        .tc         (tc_pwm_symb)
    );

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        counter_start <= 1'b0;
        read <= 1'b0;
        pwm <= 1'b0;
        
        if (rst == 1'b1) begin
            counter_duty <= 0;
            state <= ST_IDLE;
        end else if (enable == 1'b1) begin
            case (state)
                ST_IDLE:
                begin
                    if (empty == 1'b0) begin
                        read <= 1'b1;
                        counter_start <= 1'b1;
                        state <= ST_RUNNING;
                    end
                end

                ST_RUNNING:
                begin
                    if (tc_pwm_step == 1'b1) begin
                        if(counter_duty < sample)
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

endmodule

