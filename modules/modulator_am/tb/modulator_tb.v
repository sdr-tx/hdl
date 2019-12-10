`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_modulator;

    reg rst, enable, empty;
    wire pwm, read, symb_clk, nsync, bclk;
    reg [7:0] sample;

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #10 clk = !clk;


    modulator #(
        .PARAMETER01(1000),    // AM_CLKS_PER_PWM_STEP
        .PARAMETER02(255),  // AM_PWM_STEP_PER_SAMPLE
        .PARAMETER03(8)     // AM_BITS_PER_SAMPLE
    ) dut (
        .clk      (clk),
        .rst      (rst),
        .enable   (enable),
        /* FIFO interface */
        .sample   (sample),
        .empty    (empty),
        .read     (read),
        /* data flow */
        .nsync    (nsync),
        .bclk     (bclk),
        .pwm      (pwm),

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
        sample <= 8'h03;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h05;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h00;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h0F;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h02;
        wait (read == 1);
        #2000
        $finish;
    end

endmodule 
