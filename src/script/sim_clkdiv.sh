#!/bin/bash
set -ex

mkdir -p build/sim
verilator -cc src/sim/clkdiv_tb.v src/hdl/clkdiv.v src/hdl/tff.v -Mdir build/verilator --binary --trace
./build/verilator/Vclkdiv_tb