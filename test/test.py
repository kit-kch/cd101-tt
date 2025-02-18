# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

from bitarray import bitarray
from collections import namedtuple

SPIConfig = namedtuple("SPIConfig", ["adsr_ai", "adsr_di", "adsr_s", "adsr_ri", "osc_count", "filter_a", "filter_b"])

def bitarray_reverse(arr):
    arr.reverse()
    return arr

def int2bits(n, nbits):
    return f"{n & ((1 << nbits) - 1):0{nbits}b}"

class CD101SPI:
    def __init__(self, dut):
        self.nss = dut.uio_in[0]
        self.mosi = dut.uio_in[1]
        self.sck = dut.uio_in[3]
        self.sysclk = dut.clk

    async def __write(self, data, finalDelay = 1, initialDelay = 1):
        # NSS low
        self.nss.value = 0

        # SPI is 1 MHz clock
        await ClockCycles(self.sysclk, initialDelay * 24)

        for bval in data:
            self.mosi.value = bval
            await ClockCycles(self.sysclk, 12)
            self.sck.value = 1
            await ClockCycles(self.sysclk, 12)
            self.sck.value = 0

        await ClockCycles(self.sysclk, finalDelay * 24)
        self.nss.value = 1

    async def set_trigger(self, on):
        if (on):
            await self.__write(bitarray('1'))
        else:
            await self.__write(bitarray('0'))

    async def set_config(self, trig, cfg):
        data = bitarray()
        if (trig):
            data.append(1)
        else:
            data.append(0)
        
        data.extend(bitarray_reverse(bitarray(int2bits(cfg.adsr_ai, 8))))
        data.extend(bitarray_reverse(bitarray(int2bits(cfg.adsr_di, 8))))
        data.extend(bitarray_reverse(bitarray(int2bits(cfg.adsr_s, 8))))
        data.extend(bitarray_reverse(bitarray(int2bits(cfg.adsr_ri, 8))))
        data.extend(bitarray_reverse(bitarray(int2bits(cfg.osc_count, 12))))
        data.extend(bitarray_reverse(bitarray(int2bits(cfg.filter_a, 8))))
        data.extend(bitarray_reverse(bitarray(int2bits(cfg.filter_b, 8))))

        await self.__write(data)

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock to 24 MHz
    clock = Clock(dut.clk, 41.666, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.rst_n.value = 1
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.uio_in[0].value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 0

    # Reset needs to be quite long, as its synchronous on slow clk
    await ClockCycles(dut.clk, int(0.003125 * 24000000))
    dut.rst_n.value = 1

    dut._log.info("Testing Audio Generation")
    spi = CD101SPI(dut)
    
    config = SPIConfig(64, -10, 125, -4, 66, 101, 255-101)
    await spi.set_config(False, config)
    
    await ClockCycles(dut.clk, 10)
    await spi.set_trigger(True)

    # FIXME: Check output. This is really slow...
    await ClockCycles(dut.clk, 2400000)

    # Set the input values you want to test
#    dut.ui_in.value = 20
#    dut.uio_in.value = 30

    # Wait for one clock cycle to see the output values
#    await ClockCycles(dut.clk, 1)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
#    assert dut.uo_out.value == 50

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
