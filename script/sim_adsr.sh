#!/bin/bash
set -ex

verilator -cc src/sim/adsr_tb.v src/hdl/adsr.v  --binary --trace
./obj_dir/Vadsr_tb