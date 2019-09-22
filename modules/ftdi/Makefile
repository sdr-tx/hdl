CC = iverilog
FLAGS = -Wall -­Winfloop

simulation: ../../top/top_level_sim.v ft245_fifo_interface.v tb/ft245_fifo_interface_tb.v ../controller/controller.v ../counter/counter.v ../decoder/decoder.v 

	$(CC) -o sim ../../top/top_level_sim.v ft245_fifo_interface.v tb/ft245_fifo_interface_tb.v ../controller/controller.v ../counter/counter.v ../decoder/decoder.v 
	vvp sim
	gtkwave waveform.vcd 
