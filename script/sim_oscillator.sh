#!/bin/bash
set -ex

verilator -cc src/sim/oscillator_tb.v src/hdl/oscillator.v  --binary --trace
./obj_dir/Voscillator_tb