// Blink an LED provided an input clock
/* module */
module top_level (hwclk,rst,pwm);
    /* I/O */
    input hwclk;
    input rst;
    output pwm;
    reg clk,aux;

    /* my pll */
    pll_128MHz general_clk(
    	.clock_in   (hwclk),
    	.clock_out  (clk),
    	.locked     (aux)
	);

  modulator  #(.FOO(10),.AM_CLKS_IN_PWM_STEPS(`AM_PWM_STEPS),.AM_PWM_STEPS(`AM_PWM_STEPS))
                 dut (clk,rst,pwm);
endmodule

