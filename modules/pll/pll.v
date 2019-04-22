/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:        12.000 MHz
 * Requested output frequency:  275.000 MHz
 * Achieved output frequency:   276.000 MHz
 */

//250 MHZ
module pll(
	input  clock_in,
	output clock_out,
	output locked
	);

wire g_clock_in;
wire g_lock_in;

SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(4'b0000),		// DIVR =  0
		.DIVF(7'b0101101),	// DIVF = 22
		.DIVQ(3'b001),		// DIVQ =  1
		.FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
	) uut (
		.LOCK(g_lock_in),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(clock_in),
		.PLLOUTCORE(g_clock_in)
		);


 SB_GB clk_gb ( .USER_SIGNAL_TO_GLOBAL_BUFFER(g_clock_in)		
                  , .GLOBAL_BUFFER_OUTPUT(clock_out) );	

   									
 SB_GB lck_gb ( .USER_SIGNAL_TO_GLOBAL_BUFFER(g_lock_in)		
                  , .GLOBAL_BUFFER_OUTPUT(locked) );			
								

endmodule
