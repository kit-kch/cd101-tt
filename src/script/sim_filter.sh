#!/bin/bash
set -ex

verilator -cc src/sim/filter_tb.v src/hdl/filter.v -Mdir build/verilator --binary --trace
./build/verilator/Vfilter_tb