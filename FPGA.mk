####################################################################################################
# Configuration
####################################################################################################
TOP_MODULE = fpga_top
DESIGN = fpga_top
APP_VERILOG = tff.v \
	clkdiv.v \
	dac.v \
	shift_mult8.v \
	shift_mult16.v \
	filter.v \
	oscillator.v \
	adsr.v \
	synth.v \
	spi.v \
	synth_top.v \
	fpga_pll.v \
	fpga_top.v

NTHREADS ?= 4

####################################################################################################
# Abbreviations
####################################################################################################
OBJDIR=build
RPTDIR=$(OBJDIR)/rpt
SRCDIR=src
CONDIR=$(SRCDIR)/constraints
HDLDIR=$(SRCDIR)/hdl

####################################################################################################
# Generated variables
####################################################################################################
SYN_VERILOG_PATHS=$(addprefix $(HDLDIR)/,$(APP_VERILOG))

QUIET_FLAG=
ifeq ($(strip $(VERBOSE)),)
	QUIET_FLAG=-q
endif

####################################################################################################
# Tool Commands
####################################################################################################
SCRIPT_SUMMARY="$(abspath ./script/summary.py)"

####################################################################################################
# Rules
####################################################################################################
.PHONY: all synth pnr bitstream summary upload
.PRECIOUS: $(OBJDIR)/%.syn.json $(OBJDIR)/%.pnr.json

# High-level wrapper targets
all: bitstream summary

clean:
	rm -rf $(OBJDIR)

synth: $(OBJDIR)/$(DESIGN).syn.json

pnr: $(OBJDIR)/$(DESIGN).pnr.asc

bitstream: $(OBJDIR)/$(DESIGN).bin

summary: $(RPTDIR)/$(DESIGN).pnr.json
	@echo
	@echo ========================== Device Summary ==========================
	@echo
	@$(SCRIPT_SUMMARY) $<

upload:
	iceprog -S $(OBJDIR)/$(DESIGN).bin

upload-flash:
	iceprog $(OBJDIR)/$(DESIGN).bin

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(RPTDIR):
	mkdir -p $(RPTDIR)


####################################################################################################
# Automatic rule patterns: Create output(s) from input(s)
####################################################################################################

# Synthesis
$(OBJDIR)/%.syn.json: $(SYN_VERILOG_PATHS) | $(OBJDIR) $(RPTDIR)
	yosys -p "read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog $(SYN_VERILOG_PATHS); synth_ice40 -top $(TOP_MODULE) -json $@; tee -o $(RPTDIR)/$*.syn.res.rpt stat" \
	  $(QUIET_FLAG) -l $(RPTDIR)/$*.syn.log --detailed-timing

# Place and route
$(OBJDIR)/%.pnr.asc $(RPTDIR)/%.pnr.json &: $(OBJDIR)/%.syn.json $(CONDIR)/%.pcf $(CONDIR)/%.py | $(OBJDIR) $(RPTDIR) 
	nextpnr-ice40 --up5k --package sg48 --json $(OBJDIR)/$*.syn.json --asc $(OBJDIR)/$*.pnr.asc \
	  --report $(RPTDIR)/$*.pnr.json \
	  --pcf $(CONDIR)/$*.pcf --pre-pack $(CONDIR)/$*.py $(QUIET_FLAG) -l $(RPTDIR)/$*.pnr.log \
	  --threads $(NTHREADS) --detailed-timing-report

# Bitstream generation / Packing
$(OBJDIR)/%.bin: $(OBJDIR)/%.pnr.asc | $(OBJDIR)
	icepack $< $@