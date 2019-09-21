CC = iverilog
FLAGS = -Wall -­Winfloop

simulation: ../../top/top_level.v ft245_fifo_interface.v tb/ft245_fifo_interface_tb.v ../controller/controller.v ../counter/counter.v

	$(CC) -o sim ../../top/top_level.v ft245_fifo_interface.v tb/ft245_fifo_interface_tb.v ../controller/controller.v ../counter/counter.v
	vvp sim
	gtkwave waveform.vcd 
