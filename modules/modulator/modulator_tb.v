`include "../../inc/project_defines.v"

module test_modulator;

  reg rst = 1;

  
  /* Make a regular pulsing clock. */
  reg clk = 0;

  always #1 clk = !clk;


  modulator  #(.FOO(10),.AM_CLKS_IN_PWM_STEPS(`AM_PWM_STEPS),.AM_PWM_STEPS(`AM_PWM_STEPS))
  				 dut (clk,rst,pwm);

        initial begin
            $dumpfile ("waveform.vcd");
            $dumpvars (0,test_modulator);
            rst<=1;
            #5
            rst<=0;
            
            #2005;
            $finish;

        end
endmodule 
