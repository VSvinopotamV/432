set script_dir [file dirname [file normalize [info script]]]

create_project axi_bcd_filter "$script_dir/vivado_project" -part xc7a100tcsg324-1 -force

add_files "$script_dir/rtl/axi_bcd_filter.sv"
add_files -fileset sim_1 "$script_dir/tb/axi_bcd_filter_tb.sv"

set_property file_type SystemVerilog [get_files "$script_dir/rtl/axi_bcd_filter.sv"]
set_property file_type SystemVerilog [get_files "$script_dir/tb/axi_bcd_filter_tb.sv"]

set_property top axi_bcd_filter [current_fileset]
set_property top tb_axi_bcd_filter [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

launch_simulation