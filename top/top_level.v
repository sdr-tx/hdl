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

    /* Counter register */
    reg [7:0] counter = 8'b0;
    reg [23:0] second = 24'b0;

    reg [7:0] counter2 = 8'b0;
    reg [23:0] second2 = 24'b0;

    wire salida;

    /* my pll */
    pll my_pll275MHZ(
	.clock_in   (hwclk),
	.clock_out  (clk),
	.locked     (aux)
	);

     /* my pll */
    pll2 my_pll16MHZ(
    .clock_in   (hwclk),
    .clock_out  (clk2),
    .locked     (aux2)
    );

    wire salida;

    //salida <= clk & clk;


    /* LED drivers */
    assign led1 = counter[0];
    assign led2 = counter[1];
    assign led3 = counter[2];
    assign led4 = counter[3];
    assign led5 = counter2[0];
    assign led6 = clk & counter[2];
    assign led7 = clk2 & clk;
    assign led8 = clk;

    /* always */
    always @ (posedge clk) begin
        second <= second + 1;

        // second counter
        if ( second == 24'd16000000 )
        begin
            counter <= counter + 1;
            second <= 24'd0;
        end
    end


        /* always */
    always @ (posedge clk2) begin
        second2 <= second2 + 1;

        // second counter
        if ( second2 == 24'd16000000 )
        begin
            counter2 <= counter2 + 1;
            second2 <= 24'd0;
        end
    end

endmodule
