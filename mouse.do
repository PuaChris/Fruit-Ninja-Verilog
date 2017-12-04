# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
# could also have multiple verilog files
vlog mouse.v

#load simulation using the top level simulation module
vsim mouse

#log all signals and add some signals to waveform window
log -r {/*}

# add wave {/*} would add all items in top level simulation module
add wave {/*}

radix signal x unsigned
radix signal y unsigned
radix signal current_state unsigned
radix signal next_state unsigned
radix signal byte1 unsigned
radix signal byte2 unsigned



#set input values using the force command, signal names need to be in {} brackets
#run simulation for a few ns


# clock
force {clock} 0 0ns, 1 10ns -r 20ns

# reset
force {reset} 1
force {the_command} 0
force {send_command} 0
force {command_was_sent} 0
force {error_communication_timed_out} 0
force {received_data} 0
force {received_data_en} 0
run 40ns
force {reset} 0
run 20ns




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
run 20ns

run 40ns




force {received_data} 0110_0000
force {received_data_en} 1
run 20ns
force {received_data_en} 0
run 20ns

force {received_data} 1100_0101
force {received_data_en} 1
run 20ns
force {received_data_en} 0
run 20ns

force {received_data} 0101_0100
force {received_data_en} 1
run 20ns
force {received_data_en} 0
run 20ns

run 40ns



