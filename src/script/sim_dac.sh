#!/bin/bash
set -ex

mkdir -p build/sim
verilator -cc src/sim/dac_tb.v src/hdl/dac.v -Mdir build/verilator --binary --trace
./build/verilator/Vdac_tb