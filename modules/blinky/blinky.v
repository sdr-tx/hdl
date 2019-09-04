// Blink an LED provided an input clock
/* module */
module blinky (clk, led);
    /* I/O */
    input clk;
    output led;

    /* Counter register */
    /* clk: 100MHz -> max counter 50e6 */
    reg [25:0] counter = 26'b0;

    /* always */
    always @ (posedge clk) begin
        counter <= counter + 1;

        // second counter
        if ( counter == 26'd50000000 )
        begin
            counter <= 26'd0;
            led <= ~led;
        end
    end

endmodule
