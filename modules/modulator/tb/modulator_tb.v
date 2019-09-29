`include "../../inc/project_defines.v"
`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_modulator;

  reg rst, enable, new_sample;
  wire pwm;
  reg [7:0] sample;
  
  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #10 clk = !clk;


  modulator #(
    .FOO(10),
    .AM_CLKS_IN_PWM_STEPS(10),
    .AM_PWM_STEPS(10)
  ) dut (
    .clk  (clk),
    .rst  (rst),
    .enable (enable),
    /* configuration parameters */
    .bits_per_sample  (8'd255),
    .clks_per_pwm_step(8'd2),
    .new_sample   (new_sample),
    /* data flow */
    .sample       (sample),
    .pwm  (pwm)
  );

  initial begin
      $dumpfile ("waveform.vcd");
      $dumpvars (0,test_modulator);
      rst <= 1;
      enable <= 0;
      new_sample <= 0;
      #20
      rst <= 0;
      #20
      enable <= 1;
      #20
      new_sample <= 1;
      sample <= 8'd128;
      #20
      new_sample <= 0;
      #50120;
      new_sample <= 1;
      sample <= 8'd10;
      #20
      new_sample <= 0;
      #10240;
      $finish;

  end

endmodule 
