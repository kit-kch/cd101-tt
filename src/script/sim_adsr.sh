#!/bin/bash
set -ex

verilator -cc src/sim/adsr_tb.v src/hdl/adsr.v -Mdir build/verilator --binary --trace
./build/verilator/Vadsr_tb