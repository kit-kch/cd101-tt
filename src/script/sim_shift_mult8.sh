#!/bin/bash
set -ex

mkdir -p build/sim
verilator -cc src/sim/shift_mult8_tb.v src/hdl/shift_mult8.v -Mdir build/verilator --binary --trace
./build/verilator/Vshift_mult8_tb