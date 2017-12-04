vlib work

vlog control.v
vlog clock_divider.v

vsim -L altera_mf_ver control

log {/*}
add wave {/*}
#add wave {/divider/*}

radix signal fruit_x_position unsigned
radix signal fruit_y_position unsigned
radix signal mouse_x unsigned
radix signal mouse_y unsigned
radix signal frame_counter unsigned
radix signal current_state unsigned
radix signal next_state unsigned
#radix signal divider/Count unsigned





force {clock} 0 0ns, 1 1ns -r 2ns

run 10ns
force {resetn} 0
run 10ns
force {resetn} 1

force {fruit_x_position} 0
force {fruit_y_position} 0
force {fruit_drawn} 0
force {background_drawn} 0
force {mouse_x} 'd4
force {mouse_y} 'd10
force {mouse_left_click} 0

force {begin_game} 0
run 2ns
force {begin_game} 1




force {fruit_x_position} 'd2


force {fruit_y_position} 'd0
run 10ns
force {background_drawn} 1
run 2ns
force {background_drawn} 0
run 10ns
force {fruit_drawn} 1
run 100ns
force {fruit_drawn} 0


force {fruit_y_position} 'd1
run 10ns
force {background_drawn} 1
run 2ns
force {background_drawn} 0
run 10ns
force {fruit_drawn} 1
run 100ns
force {fruit_drawn} 0


force {fruit_y_position} 'd2
run 10ns
force {background_drawn} 1
run 2ns
force {background_drawn} 0
run 10ns
force {fruit_drawn} 1
run 100ns
force {fruit_drawn} 0


force {fruit_y_position} 'd3
run 10ns
force {background_drawn} 1
run 2ns
force {background_drawn} 0
run 10ns




force {mouse_x} 'd57
force {mouse_y} 'd5
force {mouse_left_click} 1
force {fruit_x_position} 'd57


force {fruit_y_position} 'd0
run 10ns
force {background_drawn} 1
run 2ns
force {background_drawn} 0
run 10ns
force {fruit_drawn} 1
run 100ns
force {fruit_drawn} 0


force {fruit_y_position} 'd1
run 10ns
force {background_drawn} 1
run 2ns
force {background_drawn} 0
run 10ns
force {fruit_drawn} 1
run 100ns
force {fruit_drawn} 0


force {fruit_y_position} 'd2
run 10ns
force {background_drawn} 1
run 2ns
force {background_drawn} 0
run 10ns




force {fruit_y_position} 'd0
run 10ns
force {background_drawn} 1
run 2ns
force {background_drawn} 0
run 10ns
force {fruit_drawn} 1
run 100ns
force {fruit_drawn} 0






run 20ns

