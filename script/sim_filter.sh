#!/bin/bash
set -ex

verilator -cc src/sim/filter_tb.v src/hdl/filter.v  --binary --trace
./obj_dir/Vfilter_tb