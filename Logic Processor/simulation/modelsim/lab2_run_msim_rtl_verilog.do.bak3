transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/ECE\ 385/Lab\ 2/logic_processor_4bit {C:/Users/Steven Chang/Desktop/ECE 385/Lab 2/logic_processor_4bit/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/Lab2 {C:/Users/Steven Chang/Desktop/Lab2/compute.sv}
vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/Lab2 {C:/Users/Steven Chang/Desktop/Lab2/Router.sv}
vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/Lab2 {C:/Users/Steven Chang/Desktop/Lab2/Reg_8.sv}
vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/Lab2 {C:/Users/Steven Chang/Desktop/Lab2/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/Lab2 {C:/Users/Steven Chang/Desktop/Lab2/Control.sv}
vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/Lab2 {C:/Users/Steven Chang/Desktop/Lab2/Register_unit.sv}
vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/Lab2 {C:/Users/Steven Chang/Desktop/Lab2/Processor.sv}

vlog -sv -work work +incdir+C:/Users/Steven\ Chang/Desktop/Lab2/../ECE\ 385/Lab\ 2/logic_processor_4bit {C:/Users/Steven Chang/Desktop/Lab2/../ECE 385/Lab 2/logic_processor_4bit/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
