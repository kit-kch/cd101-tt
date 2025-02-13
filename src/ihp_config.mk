export DESIGN_NAME = tt_um_kch_cd101
export DESIGN_PATH := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
export PLATFORM    = ihp-sg13g2

export VERILOG_FILES = $(DESIGN_PATH)hdl/tff.v \
    $(DESIGN_PATH)hdl/clkdiv.v \
    $(DESIGN_PATH)hdl/oscillator.v \
    $(DESIGN_PATH)hdl/adsr.v \
    $(DESIGN_PATH)hdl/dac.v \
    $(DESIGN_PATH)hdl/shift_mult8.v \
    $(DESIGN_PATH)hdl/shift_mult16.v \
    $(DESIGN_PATH)hdl/filter.v \
    $(DESIGN_PATH)hdl/synth.v \
    $(DESIGN_PATH)hdl/spi.v \
    $(DESIGN_PATH)hdl/synth_top.v \
    $(DESIGN_PATH)hdl/ihp_top.v

export SDC_FILE      = $(DESIGN_PATH)constraints/ihp/constraints.sdc
export FOOTPRINT_TCL = $(DESIGN_PATH)constraints/ihp/footprint.tcl
export SEAL_GDS = $(DESIGN_PATH)constraints/ihp/sealring.gds

# (Sealring: roughly 60um)
# I/O pads: 180um
# Bondpads: 70um
# Margin for core power ring: 20um
# Total margin to core area: 270um
export DIE_AREA  =   0   0 945 945
export CORE_AREA = 270 270 675 675

export USE_FILL = 1
export YOSYS_FLAGS = -D USE_CFG_LATCH

#export PLACE_DENSITY ?= 0.88
#export CORE_UTILIZATION = 20
