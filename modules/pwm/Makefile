CC = iverilog
FLAGS = -Wall -­Winfloop

simulation: pwm.v tb/pwm_tb.v ../counter/counter.v

	$(CC) -o sim pwm.v tb/pwm_tb.v ../counter/counter.v
	vvp sim
	gtkwave waveform.vcd 
