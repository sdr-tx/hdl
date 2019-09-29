`include "../../inc/project_defines.v"

module modulator #(
    parameter FOO = 10,
    parameter AM_CLKS_IN_PWM_STEPS = `AM_CLKS_IN_PWM_STEPS,
    parameter AM_PWM_STEPS = `AM_PWM_STEPS
)(
    input clk,
    input rst,
    input enable,
    /* configuration parameters */
    input [7:0] bits_per_sample,
    input [7:0] clks_per_pwm_step,
    input new_sample,
    /* data flow */
    input [7:0] sample,
    output reg pwm
);
    localparam WIDTH = $clog2(FOO);

    /* registers */
    reg [WIDTH-1:0] count;
    wire tc_pwm_step, tc_pwm_symb;
    reg [AM_PWM_STEPS-1:0] shift_register;
    reg [7:0] sample_reg, counter_duty;
    wire counter_rst;
    assign counter_rst = new_sample | rst;

    // counter to generate ticks at pwm-steps frequency
    module_counter #(
        .WIDTH  (8)
    ) inst_counter_pwm_steps (
        .clk    (clk),
        .rst    (counter_rst),
        .enable (1'b1),
        .max_count (clks_per_pwm_step),
        .tc     (tc_pwm_step)
    );

    // counter to generate ticks at pwm-symbols frequency
    module_counter #(
        .WIDTH  (8)
    ) inst_counter_pwm_symb (
        .clk    (clk),
        .rst    (counter_rst),
        .enable (tc_pwm_step),
        .max_count (bits_per_sample),
        .tc     (tc_pwm_symb)
    );

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            sample_reg <= 0;
            counter_duty <= 0;
        end else if (enable == 1'b1) begin
            if (new_sample == 1'b1) begin
                counter_duty <= 8'd0;
                sample_reg <= sample;
            end else if (tc_pwm_step == 1'b1) begin
                if(counter_duty > sample_reg)
                    pwm <= 1'b0;
                else begin
                    counter_duty <= counter_duty + 1;
                    pwm <= 1'b1;
                end
            end
        end else begin
            pwm <= 1'b0;
        end
    end

    // // output assignment
    // assign pwm = counter_duty < sample ? 1:0;


endmodule


