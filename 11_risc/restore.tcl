
# NC-Sim Command File
# TOOL:	ncsim	10.20-p008
#
#
# You can restore this configuration with:
#
#      irun -f files.txt -access rwc -input restore.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 1
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
alias . run
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves risc_test.risc_inst.clk risc_test.risc_inst.rst risc_test.risc_inst.halt risc_test.risc_inst.sel risc_test.risc_inst.rd risc_test.risc_inst.ld_ir risc_test.risc_inst.inc_pc risc_test.risc_inst.ld_pc risc_test.risc_inst.data_e risc_test.risc_inst.ld_ac risc_test.risc_inst.wr risc_test.risc_inst.pc_addr risc_test.risc_inst.addr risc_test.risc_inst.data risc_test.risc_inst.opcode risc_test.risc_inst.ir_addr risc_test.risc_inst.acc_out risc_test.risc_inst.alu_out risc_test.risc_inst.zero

simvision -input restore.tcl.svcf
