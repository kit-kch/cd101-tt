#!/bin/bash
set -ex

verilator -cc src/sim/clkdiv_tb.v src/hdl/clkdiv.v src/hdl/dff.v  --binary --trace
./obj_dir/Vclkdiv_tb