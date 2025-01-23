#!/bin/bash
set -ex

mkdir -p build/sim
verilator -cc src/sim/spi_tb.v src/hdl/spi.v -Mdir build/verilator --binary --trace
./build/verilator/Vspi_tb