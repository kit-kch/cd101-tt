#!/bin/bash
set -ex

verilator -cc src/sim/dac_tb.v src/hdl/dac.v --binary --trace
./obj_dir/Vdac_tb