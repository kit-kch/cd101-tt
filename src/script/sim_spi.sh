#!/bin/bash
set -ex

verilator -cc src/sim/spi_tb.v src/hdl/spi.v -Mdir build/verilator --binary --trace
./build/verilator/Vspi_tb