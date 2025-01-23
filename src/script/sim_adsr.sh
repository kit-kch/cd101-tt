#!/bin/bash
set -ex

mkdir -p build/sim
verilator -cc src/sim/adsr_tb.v src/hdl/adsr.v -Mdir build/verilator --binary --trace
./build/verilator/Vadsr_tb