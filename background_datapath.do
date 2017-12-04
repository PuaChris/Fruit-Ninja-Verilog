vlib work

vlog background_datapath.v
vlog background.v

vsim -L altera_mf_ver background_datapath

log {/*}
add wave {/*}

radix signal background_x_position unsigned
radix signal background_y_position unsigned
radix signal background_counter unsigned





force {clock} 0 0ns, 1 1ns -r 2ns

force {draw_background} 0
run 10ns
force {resetn} 0
run 10ns
force {resetn} 1
run 10ns


force {draw_background} 1
run 40000ns
force {draw_background} 0
run 10ns

