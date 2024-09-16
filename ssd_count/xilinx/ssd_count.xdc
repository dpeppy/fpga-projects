########################################
# I/O Constraints
########################################
set_property PACKAGE_PIN H16             [get_ports {clock}]
set_property IOSTANDARD  LVCMOS33        [get_ports {clock}]

set_property PACKAGE_PIN D19             [get_ports {reset}]
set_property IOSTANDARD  LVCMOS33        [get_ports {reset}]

set_property PACKAGE_PIN D20             [get_ports {button}]
set_property IOSTANDARD  LVCMOS33        [get_ports {button}]

set_property PACKAGE_PIN Y18             [get_ports {ssd_seg[0]}]
set_property PACKAGE_PIN Y19             [get_ports {ssd_seg[1]}]
set_property PACKAGE_PIN Y16             [get_ports {ssd_seg[2]}]
set_property PACKAGE_PIN Y17             [get_ports {ssd_seg[3]}]
set_property PACKAGE_PIN W14             [get_ports {ssd_seg[4]}]
set_property PACKAGE_PIN Y14             [get_ports {ssd_seg[5]}]
set_property PACKAGE_PIN T11             [get_ports {ssd_seg[6]}]
set_property PACKAGE_PIN T10             [get_ports {ssd_sel}]
set_property IOSTANDARD  LVCMOS33        [get_ports {ssd_*}]
set_property DRIVE       8               [get_ports {ssd_*}]

########################################
# Clock Constraints
########################################
create_clock -name clk_125 -period 8.0 [get_ports {clock}]