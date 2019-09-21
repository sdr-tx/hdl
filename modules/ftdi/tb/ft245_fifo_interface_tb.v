`include "../../inc/project_defines.v"
`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_modulator;

  reg rst = 1;
  
  /* Make a regular pulsing clock. */
  reg clk = 0;
  reg [7:0] in_245;
  wire rx_245, wr_245;
  reg rxf_245, txe_245;

  always #10 clk = !clk;

  top_level dut (
    .clk        (clk),
    .rst        (rst),
    .leds       (),
    // FT245 interface
    .in_245     (in_245),
    .out_245    (),
    .tx_oe_245  (),
    .rxf_245    (rxf_245),
    .rx_245     (rx_245),
    .txe_245    (txe_245),
    .wr_245     (wr_245),


    // --- test ---
    .fake_rst   ()
  );

  initial begin
      $dumpfile ("waveform.vcd");
      $dumpvars (0,test_modulator);
      rst <= 1;
      txe_245 <= 1'b1;
      rxf_245 <= 1'b1;
      #20
      rst <= 0;
      #20
      in_245 <= 8'hAA;
      rxf_245 <= 1'b0;
      #150
      rxf_245 <= 1'b1;
      #1500000;
      $finish;

  end
endmodule 
