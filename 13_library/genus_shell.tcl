# genus -files genus_shell.tcl
if ![info exists env(GENUSHOME)] {puts "PLEASE SET \"GENUSHOME\" VARIABLE!"; exit 1}
set_db hdl_auto_async_set_reset true
set_db exact_match_seq_async_ctrls true
# set_db library $env(GENUSHOME)/share/synth/tutorials/tech/tutorial.lbr
read_libs $env(GENUSHOME)/share/synth/tutorials/tech/tutorial.lib
read_hdl lib.v -v2001
elaborate
foreach design {priority7 latchrs dffrs drive8} {vcd $design ; check_design $design}
# suspend
define_clock -period 67000 -name L15MHz [get_db design:latchrs .ports e]

external_delay -clock L15MHz -input  40000 [get_db design:latchrs .ports -if {.direction==in}]
external_delay -clock L15MHz -output 27000 [get_db design:latchrs .ports -if {.direction==out}]

define_clock -period 67000 -name D15MHz [get_db design:dffrs .ports c]

external_delay -clock D15MHz -input  40000 [get_db design:dffrs .ports -if {.direction==in}]
external_delay -clock D15MHz -output 27000 [get_db design:dffrs .ports -if {.direction==out}]

path_delay -delay 30000 -from [get_db design:priority7 .ports -if {.direction==in}] -to [get_db design:priority7 .ports -if {.direction==out}]
path_delay -delay 25000 -from [get_db design:drive8 .ports -if {.direction==in}] -to [get_db design:drive8 .ports -if {.direction==out}]
syn_generic
syn_map
syn_opt
foreach design {priority7 latchrs dffrs drive8} {write_hdl $design > $design.vg}
#exit
