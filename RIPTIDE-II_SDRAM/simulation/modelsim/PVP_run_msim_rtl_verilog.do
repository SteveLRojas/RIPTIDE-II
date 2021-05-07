transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/VGA.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/toplevel.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/shift_merge.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/RIPTIDE_II.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/right_rotate.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/PC.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/p_cache.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/MSC.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/mask_unit.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/internal_mem.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/hazard_unit.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/decode_unit.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/d_cache.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/ALU.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/SDRAM_DP64_I.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/p_mem.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/PRG_ROM.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/VGA_RAM.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/CHR_ROM.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/PLL0.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM/db {E:/RIPTIDE-II_SDRAM/db/pll0_altpll.v}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/MULTIPLEXED_HEX_DRIVER.sv}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/MC6847_gen3.sv}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/UART.sv}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/serial.sv}

vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/ALU.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/CHR_ROM.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/d_cache.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/decode_unit.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/hazard_unit.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/internal_mem.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/mask_unit.v}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/MC6847_gen3.sv}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/MSC.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/p_cache.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/p_mem.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/PC.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/PLL0.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/PRG_ROM.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/right_rotate.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/RIPTIDE_II.v}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/sdr.sv}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/sdr_parameters.sv}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/SDRAM_DP64_I.v}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/serial.sv}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/shift_merge.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/testbench.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/toplevel.v}
vlog -sv -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/UART.sv}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/VGA.v}
vlog -vlog01compat -work work +incdir+E:/RIPTIDE-II_SDRAM {E:/RIPTIDE-II_SDRAM/VGA_RAM.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  Testbench

add wave *
view structure
view signals
run 1000 us
