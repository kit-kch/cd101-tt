#!/bin/bash
set -ex

verilator -cc src/sim/spi_tb.v src/hdl/spi.v --binary --trace
./obj_dir/Vspi_tb