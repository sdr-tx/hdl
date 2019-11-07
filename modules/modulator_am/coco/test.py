import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock
import random

@cocotb.coroutine
def reset(dut):
    dut.rst <= 0
    yield RisingEdge(dut.clk)
    dut.rst <= 1
    yield RisingEdge(dut.clk)
    dut.rst <= 0
    yield RisingEdge(dut.clk)

@cocotb.test()
def test_modulator(dut):
    dut.enable <= 1
    dut.empty <= 0
    dut.sample <= random.randint(1, 10)
    cocotb.fork(Clock(dut.clk, 10, 'ns').start())
    yield reset(dut)
    while True:
        yield RisingEdge(dut.clk)
        dut.sample <= random.randint(1, 10)
