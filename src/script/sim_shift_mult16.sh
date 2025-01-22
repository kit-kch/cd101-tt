#!/bin/bash
set -ex

verilator -cc src/sim/shift_mult16_tb.v src/hdl/shift_mult16.v -Mdir build/verilator --binary --trace
./build/verilator/Vshift_mult_tb