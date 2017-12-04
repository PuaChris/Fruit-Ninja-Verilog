vlib work

vlog fruit_datapath.v
vlog lfsr.v
vlog x_position.v

vsim -L altera_mf_ver fruit_datapath

log {/*}
add wave {/*}
#add wave {/divider/*}

radix signal fruit_x_position unsigned
radix signal fruit_y_position unsigned
radix signal fruit_x_out unsigned
radix signal fruit_y_out unsigned
radix signal fruit_colour binary
radix signal random_xpos unsigned
radix signal new_random_xpos unsigned
radix signal fruit_draw_counter unsigned





force {clock} 0 0ns, 1 1ns -r 2ns

force {new_fruit} 0
force {move_fruit} 0
force {draw_fruit} 0
run 10ns
force {resetn} 0
run 10ns
force {resetn} 1
run 10ns




force {new_fruit} 1
run 10ns
force {new_fruit} 0
run 10ns

force {move_fruit} 1
run 20ns
force {move_fruit} 0
run 10ns

force {draw_fruit} 1
run 40ns
force {draw_fruit} 0
run 10ns

force {new_fruit} 1
run 10ns
force {new_fruit} 0
run 10ns

force {move_fruit} 1
run 100ns
force {move_fruit} 0
run 20ns

force {new_fruit} 1
run 10ns
force {new_fruit} 0
run 10ns





