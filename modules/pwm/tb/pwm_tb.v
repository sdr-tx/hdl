`include "../../inc/project_defines.v"
`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_pwm;

reg rst = 1;
reg clk = 0;
reg [5:0] duty = 10;
reg tmp;

/* Make a regular pulsing clock. */
always #10 clk = !clk;


integer data_file ; // file handler

pwm_generator  #(.FOO(10),.AM_CLKS_IN_PWM_STEPS(`AM_PWM_STEPS),.AM_PWM_STEPS(`AM_PWM_STEPS))
                 dut (clk,rst,enable,duty,symbol,pwm);

initial begin

    $dumpfile ("waveform.vcd");
    $dumpvars (0,test_pwm);


    data_file = $fopen("./scripts/data_pwm_dec.dat", "r");
   
    if (data_file == `NULL) begin
       $display("data_file handle was NULL");
       $finish;
    end
 
    rst<=1;
    #20
    rst<=0;

    while (! $feof(data_file)) begin 
        #2590
        tmp = $fscanf(data_file,"%d\n",duty);
        $display("Input signal value: %d",duty);
    end

      #1500000;
      $finish;

end





  
endmodule 
