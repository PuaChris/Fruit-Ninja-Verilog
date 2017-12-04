vlib work

vlog main.v
vlog mouse.v
vlog datapath.v
vlog control.v
vlog clock_divider.v
vlog background.v
vlog lfsr2.v
vlog background_datapath.v
vlog fruit_datapath.v
vlog background.v
vlog gameover_background.v
vlog start_background.v
vlog apple.v

vsim -L altera_mf_ver main

log {/*}
add wave {/*}
add wave {/m/*}

radix signal x_out unsigned
radix signal y_out unsigned
radix signal mouse_x unsigned
radix signal mouse_y unsigned
radix signal fruit_x_position unsigned
radix signal fruit_y_position unsigned
radix signal fruit_x_out unsigned
radix signal fruit_y_out unsigned
radix signal fruit_colour binary
radix signal background_x_position unsigned
radix signal background_y_position unsigned
radix signal current_state unsigned




force {clock} 0 0ns, 1 1ns -r 2ns
force {resetn} 1
force {begin_game} 1

run 10 ns
force {resetn} 0
run 10 ns

force {resetn} 1
run 10ns
force {begin_game} 0

run 10ns

force {resetn} 1
force {begin_game} 1


force {received_data} 0100_0000
force {received_data_en} 1
run 20ns
force {received_data_en} 0
run 20ns

force {received_data} 0011_0100
force {received_data_en} 1
run 20ns
force {received_data_en} 0
run 20ns

force {received_data} 0011_0001
force {received_data_en} 1
run 20ns
force {received_data_en} 0





run 40000ns

