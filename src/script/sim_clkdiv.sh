#!/bin/bash
set -ex

verilator -cc src/sim/clkdiv_tb.v src/hdl/clkdiv.v src/hdl/dff.v -Mdir build/verilator --binary --trace
./build/verilator/Vclkdiv_tb