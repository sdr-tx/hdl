`include "../../inc/project_defines.v"
`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 10 ps

module test_modulator;

  reg rst = 1;
  
  /* Make a regular pulsing clock. */
  reg clk = 0;
  reg [7:0] rx_data_245;
  wire rx_245, wr_245;
  reg rxf_245, txe_245;

  always #10 clk = !clk;

  top_level dut (
    .clk        (clk),
    .rst        (rst),
    .leds       (),
    // FT245 interface
    .rx_data_245(rx_data_245),
    .rxf_245    (rxf_245),
    .rx_245     (rx_245),
    .tx_data_245(),
    .txe_245    (txe_245),
    .wr_245     (wr_245),
    .tx_oe_245  (),
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

      // first word
      #20
      rx_data_245 <= 8'hAA;
      rxf_245 <= 1'b0;
      #150
      rxf_245 <= 1'b1;
      
      // second word
      #20
      rx_data_245 <= 8'hAA;
      rxf_245 <= 1'b0;
      #150
      rxf_245 <= 1'b1;
      
      #140
      txe_245 <= 1'b0;
      // // third word
      // #20
      // rx_data_245 <= 8'hAA;
      // rxf_245 <= 1'b0;
      // #150
      // rxf_245 <= 1'b1;
      
      // // fourth word
      // #20
      // rx_data_245 <= 8'hAA;
      // rxf_245 <= 1'b0;
      // #150
      // rxf_245 <= 1'b1;

      // // fifth word
      // #20
      // rx_data_245 <= 8'hAA;
      // rxf_245 <= 1'b0;
      // #150
      // rxf_245 <= 1'b1;

      #1500000;
      $finish;

  end
endmodule 
