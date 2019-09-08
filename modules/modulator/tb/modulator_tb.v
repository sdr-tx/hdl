`include "../../inc/project_defines.v"
`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_modulator;

  reg rst = 1;

  
  /* Make a regular pulsing clock. */
  reg clk = 0;

  always #10 clk = !clk;


  modulator  #(.FOO(10),.AM_CLKS_IN_PWM_STEPS(`AM_PWM_STEPS),.AM_PWM_STEPS(`AM_PWM_STEPS))
  				 dut (clk,rst,pwm);

        initial begin
            $dumpfile ("waveform.vcd");
            $dumpvars (0,test_modulator);
            rst<=1;
            #20
            rst<=0;
            #1500000;
            $finish;

        end
endmodule 
