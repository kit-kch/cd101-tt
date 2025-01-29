#!/bin/bash
set -ex

mkdir -p build/sim
verilator -cc src/sim/synth_tb.v src/hdl/synth.v src/hdl/adsr.v src/hdl/oscillator.v src/hdl/filter.v src/hdl/dac.v src/hdl/clkdiv.v src/hdl/tff.v src/hdl/shift_mult16.v src/hdl/shift_mult8.v -Mdir build/verilator --binary --trace
./build/verilator/Vsynth_tb