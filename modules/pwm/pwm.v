`include "../../inc/project_defines.v"

module pwm_generator #(
    parameter FOO = 10,
    parameter AM_CLKS_IN_PWM_STEPS = `AM_CLKS_IN_PWM_STEPS,
    parameter AM_PWM_STEPS = `AM_PWM_STEPS
)(
    input clk,
    input rst,
    input enable,
    input [5:0] duty,
    output symbol,
    output pwm
);
    localparam WIDTH = $clog2(FOO);

    /* registers */
    wire tc_pwm_step, tc_pwm_symb;
    reg [AM_PWM_STEPS-1:0] shift_register;
    reg symbol_sig;

    /******** testing signals ********/
    reg [10:0] counter_sine_10k;
    reg [10:0] counter_duty;
    /******** testing signals ********/


    // counter to generate ticks at pwm-steps frequency
    counter #(
        .MODULE  (`AM_CLKS_IN_PWM_STEPS)
    ) inst_counter_pwm_steps (
        .clk    (clk),
        .rst    (rst),
        .enable (1'b1),
        .tc     (tc_pwm_step)
    );

    // counter to generate ticks at pwm-symbols frequency
    counter #(
        .MODULE  (AM_PWM_STEPS)
    ) inst_counter_pwm_symb (
        .clk    (clk),
        .rst    (rst),
        .enable (tc_pwm_step),
        .tc     (tc_pwm_symb)
    );

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        symbol_sig = 0;
        if(rst == 1'b1)begin
            counter_sine_10k <= 0;
            counter_duty<=0;
        end
        else 
        if(tc_pwm_step == 1'b1) begin
            counter_duty <= counter_duty +1;
        end

        if (tc_pwm_symb == 1'b1) begin
            counter_sine_10k <= counter_sine_10k + 1;
            counter_duty <= 0;
            
            if(counter_sine_10k == 10'd1000) begin
                counter_sine_10k = 0;
                symbol_sig=1;
            end        
        end         

    end

 assign pwm = counter_duty < duty ? 1:0;
 assign symbol = symbol_sig;
    // output assignment
 //   assign pwm = shift_register[AM_PWM_STEPS-1];

    

endmodule


