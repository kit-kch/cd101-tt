https://github.com/YosysHQ/oss-cad-suite-build


export TOP=adsr
yosys -p "read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog src/hdl/dff.v src/hdl/clkdiv.v src/hdl/dac.v src/hdl/filter.v src/hdl/oscillator.v src/hdl/adsr.v src/hdl/synth.v src/hdl/fpga_top.v; synth_ice40 -top ${TOP} -json build/${TOP}.syn.json; tee -o build/rpt/${TOP}.syn.res.rpt stat" -q -l build/rpt/${TOP}.syn.log --detailed-timing

export TOP=clkdiv
yosys -p "read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog src/hdl/dff.v src/hdl/clkdiv.v src/hdl/dac.v src/hdl/filter.v src/hdl/oscillator.v src/hdl/adsr.v src/hdl/synth.v src/hdl/fpga_top.v; synth_ice40 -top ${TOP} -json build/${TOP}.syn.json; tee -o build/rpt/${TOP}.syn.res.rpt stat" -q -l build/rpt/${TOP}.syn.log --detailed-timing

export TOP=dac
yosys -p "read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog src/hdl/dff.v src/hdl/clkdiv.v src/hdl/dac.v src/hdl/filter.v src/hdl/oscillator.v src/hdl/adsr.v src/hdl/synth.v src/hdl/fpga_top.v; synth_ice40 -top ${TOP} -json build/${TOP}.syn.json; tee -o build/rpt/${TOP}.syn.res.rpt stat" -q -l build/rpt/${TOP}.syn.log --detailed-timing

export TOP=dff
yosys -p "read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog src/hdl/dff.v src/hdl/clkdiv.v src/hdl/dac.v src/hdl/filter.v src/hdl/oscillator.v src/hdl/adsr.v src/hdl/synth.v src/hdl/fpga_top.v; synth_ice40 -top ${TOP} -json build/${TOP}.syn.json; tee -o build/rpt/${TOP}.syn.res.rpt stat" -q -l build/rpt/${TOP}.syn.log --detailed-timing

export TOP=filter
yosys -p "read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog src/hdl/dff.v src/hdl/clkdiv.v src/hdl/dac.v src/hdl/filter.v src/hdl/oscillator.v src/hdl/adsr.v src/hdl/synth.v src/hdl/fpga_top.v; synth_ice40 -top ${TOP} -json build/${TOP}.syn.json; tee -o build/rpt/${TOP}.syn.res.rpt stat" -q -l build/rpt/${TOP}.syn.log --detailed-timing

export TOP=oscillator
yosys -p "read_verilog -D ICE40_HX -lib -specify +/ice40/cells_sim.v; read_verilog src/hdl/dff.v src/hdl/clkdiv.v src/hdl/dac.v src/hdl/filter.v src/hdl/oscillator.v src/hdl/adsr.v src/hdl/synth.v src/hdl/fpga_top.v; synth_ice40 -top ${TOP} -json build/${TOP}.syn.json; tee -o build/rpt/${TOP}.syn.res.rpt stat" -q -l build/rpt/${TOP}.syn.log --detailed-timing