#!/bin/bash
set -ex

verilator -cc src/sim/synth_tb.v src/hdl/synth.v src/hdl/adsr.v src/hdl/oscillator.v  --binary --trace
./obj_dir/Vsynth_tb