#!/bin/bash
set -ex

mkdir -p build/sim
verilator -cc src/sim/filter_tb.v src/hdl/filter.v src/hdl/shift_mult16.v -Mdir build/verilator --binary --trace
./build/verilator/Vfilter_tb