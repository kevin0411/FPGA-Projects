transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/Register_unit.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/Reg_8.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/Control.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/adder9.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/Synchronizers.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/HexDriver.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/full_adder.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/subtracter9.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/multiplier_top_level.sv}

vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/ECE\ 385/Lab4 {C:/intelFPGA_lite/18.1/ECE 385/Lab4/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
