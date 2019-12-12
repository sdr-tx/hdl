`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_modulator;

    reg rst, enable, empty;
    wire pwm, read, symb_clk;
    reg [7:0] sample;

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #10 clk = !clk;


    modulator #(
        .PARAMETER01(10),   // PSK_CLKS_PER_BIT
        .PARAMETER02(4),    // PSK_BITS_PER_SYMBOL
        .PARAMETER03(0),    // 
        .PARAMETER04(5)     // PSK_REPEATED_SAMPLE
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
        sample <= 8'h00;
        #20
        rst <= 0;

        // test sending qpsk
        // symbols 0011 - 1100 - 0110 - 1001
        sample <= 8'b00000011;
        wait (read == 1);
        wait (read == 0);
        #1100 // 20*10*5

        // test that the modulator only register the sample
        // input when the previous sample was transmitted
        sample <= 8'b00001100;
        wait (read == 1);
        wait (read == 0);
        #1100

        sample <= 8'b00000110;
        wait (read == 1);
        wait (read == 0);
        #1100
    
        sample <= 8'b00001001;
        wait (read == 1);
        wait (read == 0);
        #1100

        // test that the modulator holds on idle state
        // until the fifo has a new sample
        empty <= 1;
        #800
        empty <= 0;
        #800
       $finish;
    end

endmodule 
