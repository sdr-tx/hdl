// Blink an LED provided an input clock
/* module */
module top_level (hwclk, led1, led2, led3, led4, led5, led6, led7, led8 );
    /* I/O */
    input hwclk;
    output led1;
    output led2;
    output led3;
    output led4;
    output led5;
    output led6;
    output led7;
    output led8;

    reg clk,clk2,aux,aux2;

    /* my pll */
    pll_128MHz general_clk(
    	.clock_in   (hwclk),
    	.clock_out  (clk),
    	.locked     (aux)
	);

    blinky one_second_blinky (
        .clk(clk), 
        .led(led1)
    );

    counter #(
        .MODULE  (50000000),
    ) inst_counter_1sec (
        .clk    (clk),
        .rst    (rst),
        .tc     (aux)
    );

endmodule
