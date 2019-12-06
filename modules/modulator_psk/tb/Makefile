CC = iverilog
FLAGS = -Wall -­Winfloop

simulation: ../modulator.v modulator_tb.v|
	$(CC) -o sim ../modulator.v modulator_tb.v
	vvp sim
	gtkwave waveform.vcd modulator_psk.gtkw