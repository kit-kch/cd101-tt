current_design tt_um_kch_cd101

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA
#https://github.com/HEP-Alliance/masked-aes-tapeout/blob/main/constraint.sdc
#set_max_fanout 20 [current_design]
#set_max_transition 3 [current_design]
#set_max_area 0

# Pins
set spi_clk_pin {p_spi_clk}
set spi_mosi_pin {p_spi_mosi}
set spi_nss_pin {p_spi_nss}
set trigger_pin {p_trig}
set data_pin {p_data}
set rstn_pin {p_rst_n}

# Main Clock
set clk_name core_clock
set clk_port_name {p_clk}
set clk_period 40
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]
create_clock -name $clk_name -period $clk_period $clk_port
set_driving_cell -lib_cell sg13g2_IOPadIn -pin pad $clk_port
set_driving_cell -lib_cell sg13g2_IOPadIn -pin pad $rstn_pin

set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name [get_port $trigger_pin] 
set_driving_cell -lib_cell sg13g2_IOPadIn -pin pad $trigger_pin
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [get_port $data_pin]
set_driving_cell -lib_cell sg13g2_IOPadOut4mA -pin pad $data_pin


# SPI Clock
set spi_clk_name spi_clock
set spi_clk_period 100

set spi_clk_port [get_ports $spi_clk_pin]
create_clock -name $spi_clk_name -period $spi_clk_period $spi_clk_port
set_driving_cell -lib_cell sg13g2_IOPadIn -pin pad $spi_clk_port

set spi_in_ports [list [get_port $spi_mosi_pin] [get_port $spi_nss_pin]]

set_input_delay  [expr $spi_clk_period * $clk_io_pct] -clock $spi_clk_name $spi_in_ports
set_driving_cell -lib_cell sg13g2_IOPadIn -pin pad $spi_in_ports

# Internally Generated Clocks
set clk_div2_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[0].inst.q}] -filter "direction == output"]
set clk_div4_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[1].inst.q}] -filter "direction == output"]
set clk_div8_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[2].inst.q}] -filter "direction == output"]
set clk_div16_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[3].inst.q}] -filter "direction == output"]
set clk_div32_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clk_mult}] -filter "direction == output"]
set clk_div64_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[5].inst.q}] -filter "direction == output"]
set clk_div128_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[6].inst.q}] -filter "direction == output"]
set clk_div256_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clk_sample_x2}] -filter "direction == output"]
set clk_div512_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clk_sample}] -filter "direction == output"]
set clk_div1024_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[10].inst.clk}] -filter "direction == output"]
set clk_div2048_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[10].inst.q}] -filter "direction == output"]
set clk_div4096_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[11].inst.q}] -filter "direction == output"]
set clk_div8192_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[12].inst.q}] -filter "direction == output"]
set clk_div16384_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[13].inst.q}] -filter "direction == output"]
set clk_div32768_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.clki.gen[14].inst.q}] -filter "direction == output"]
set clk_div65536_pin [get_pins -of_object [get_nets -hierarchical {stop.syn.adsri.clk}] -filter "direction == output"]
create_generated_clock -name {clk_div2} -source $clk_port_name -divide_by 2 $clk_div2_pin
create_generated_clock -name {clk_div4} -source $clk_div2_pin -divide_by 2 $clk_div4_pin
create_generated_clock -name {clk_div8} -source $clk_div4_pin -divide_by 2 $clk_div8_pin
create_generated_clock -name {clk_div16} -source $clk_div8_pin -divide_by 2 $clk_div16_pin
create_generated_clock -name {clk_div32} -source $clk_div16_pin -divide_by 2 $clk_div32_pin
create_generated_clock -name {clk_div64} -source $clk_div32_pin -divide_by 2 $clk_div64_pin
create_generated_clock -name {clk_div128} -source $clk_div64_pin -divide_by 2 $clk_div128_pin
create_generated_clock -name {clk_div256} -source $clk_div128_pin -divide_by 2 $clk_div256_pin
create_generated_clock -name {clk_div512} -source $clk_div256_pin -divide_by 2 $clk_div512_pin
create_generated_clock -name {clk_div1024} -source $clk_div512_pin -divide_by 2 $clk_div1024_pin
create_generated_clock -name {clk_div2048} -source $clk_div1024_pin -divide_by 2 $clk_div2048_pin
create_generated_clock -name {clk_div4096} -source $clk_div2048_pin -divide_by 2 $clk_div4096_pin
create_generated_clock -name {clk_div8192} -source $clk_div4096_pin -divide_by 2 $clk_div8192_pin
create_generated_clock -name {clk_div16384} -source $clk_div8192_pin -divide_by 2 $clk_div16384_pin
create_generated_clock -name {clk_div32768} -source $clk_div16384_pin -divide_by 2 $clk_div32768_pin
create_generated_clock -name {clk_div65536} -source $clk_div32768_pin -divide_by 2 $clk_div65536_pin

#set clk_div32n_pin [get_pins -of_object [get_nets -hierarchical {_0037_}] -filter "direction == output"]
#create_generated_clock -name {clk_div32n} -source $clk_div16_pin -invert -divide_by 2 $clk_div32n_pin

# Let's pretend core_clock and spi_clock are mesochronous, and they never interact
set_clock_groups -asynchronous -group $clk_name -group $spi_clk_name -group {clk_div2} -group {clk_div4} -group {clk_div8} -group {clk_div16} -group {clk_div32} -group {clk_div64} -group {clk_div128} -group {clk_div256} -group {clk_div512} -group {clk_div1024} -group {clk_div2048} -group {clk_div4096} -group {clk_div8192} -group {clk_div16384} -group {clk_div32768} -group {clk_div65536} -group {clk_div32n}


set_load -pin_load 5 [all_inputs]
set_load -pin_load 5 [all_outputs]
