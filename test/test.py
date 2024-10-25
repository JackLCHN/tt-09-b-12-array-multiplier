# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test

    # Wait for one clock cycle to see the output values
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.

    #test1
    dut.ui_in.value = 0x42
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 8

    #test2
    dut.ui_in.value = 0x55
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 25
    
    #test3
    dut.ui_in.value = 0x67
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 42

    #test4
    dut.ui_in.value = 0x26
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 12

    #test5
    dut.ui_in.value = 0x38
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 24