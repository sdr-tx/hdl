CC = iverilog
FLAGS = -Wall -­Winfloop

simulation: modulator.v modulator_tb.v ../counter/counter.v

	$(CC) -o sim modulator.v modulator_tb.v ../counter/counter.v
	vvp sim
	gtkwave waveform.vcd 