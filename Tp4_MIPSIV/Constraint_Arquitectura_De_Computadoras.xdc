## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

#RESET
set_property PACKAGE_PIN T18 [get_ports reset]		
	set_property IOSTANDARD LVCMOS33 [get_ports reset]
