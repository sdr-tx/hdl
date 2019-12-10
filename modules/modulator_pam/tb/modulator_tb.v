`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_modulator;

    reg rst, enable, empty;
    wire pwm, read, symb_clk, nsync, bclk;
    reg [7:0] sample;

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #10 clk = !clk;


    modulator #(
        .PARAMETER01    (1200),
        .PARAMETER02    (12),
        .PARAMETER03    (24)
    ) dut (
        .clk      (clk),
        .rst      (rst),
        .enable   (enable),
        /* FIFO interface */
        .sample   (sample),
        .empty    (empty),
        .read     (read),
        /* data flow */
        .pwm      (pwm),    // sdata
        .nsync    (nsync),
        .bclk     (bclk),
        
        // test
        .symb_clk (symb_clk)
    );

    initial begin
        $dumpfile ("waveform.vcd");
        $dumpvars (0,test_modulator);
        rst <= 1;
        enable <= 1;
        empty <= 0;
        #20
        rst <= 0;

        // test sending some data
        sample <= 8'hAA;
        wait (read == 1);
        #20
        sample <= 8'h55;

        #2000000
        wait (read == 1);
        #20
        sample <= 8'h55;
        
        // test that the modulator holds on idle state
        // until the fifo has a new sample
        empty <= 1;
        #800
        empty <= 0;
        #800
       $finish;
    end

endmodule 
