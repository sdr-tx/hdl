# Mercurial-tx SDR

## hdl project

Here you can find all the verilog hdl code of the Mercurial-tx SDR project.
It is designed to run on a Lattice Ice40 FPGA with the icestorm tools.

## HDL Architecture

                +---------------+                +--------------+               +---------------+
                |               |  rx_data_si    |              |   sample      |               |
    +---------->+               +--------------->+              +-------------->+               |
                |               |  rx_valid_si   |              |  fifo_empty   |               |   pwm/dac
     ft245_bus  | FT245_wrapper +--------------->+     FIFO     +-------------->+  modulator_x  +------------>
                |               |  rx_ready_si   |              |  read_sample  |               |
    <-----------+               +<---------------+              +<--------------+               |
                |               |                |              |               |               |
                +---------------+                +--------------+               +---------------+

