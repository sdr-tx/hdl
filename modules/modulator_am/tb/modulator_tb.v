`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_modulator;

    reg rst, enable, empty;
    wire pwm, read, symb_clk, nsync, bclk;
    reg [7:0] sample;

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #10 clk = !clk;


    modulator #(
        .PARAMETER01(10),   // AM_CLKS_PER_PWM_STEP
        .PARAMETER02(255),  // AM_PWM_STEP_PER_SAMPLE
        .PARAMETER03(8),    // AM_BITS_PER_SAMPLE
        .PARAMETER04(5)     // AM_
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
        sample <= 8'hAA;
        #20
        rst <= 0;

        // test sending some data
        sample <= 8'h90;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h90;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h70;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h50;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h30;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h10;
        wait (read == 1);
        wait (read == 0);
        #20

        sample <= 8'h40;
        wait (read == 1);
        wait (read == 0);

        wait (read == 1);
        #80000
        $finish;
    end

endmodule 
