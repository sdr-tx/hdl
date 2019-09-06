CC = iverilog
FLAGS = -Wall -­Winfloop

simulation: modulator.v tb/modulator_tb.v ../counter/counter.v

	$(CC) -o sim modulator.v tb/modulator_tb.v ../counter/counter.v
	vvp sim
	gtkwave waveform.vcd 
