#!/bin/bash
set -ex

verilator -cc src/sim/oscillator_tb.v src/hdl/oscillator.v -Mdir build/verilator --binary --trace
./build/verilator/Voscillator_tb