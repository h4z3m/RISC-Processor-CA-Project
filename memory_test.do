vsim -gui work.addressable_memory
# End time: 16:55:19 on Apr 29,2023, Elapsed time: 0:51:42
# Errors: 2047, Warnings: 4
# vsim -gui work.addressable_memory 
# Start time: 16:55:19 on Apr 29,2023
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.math_real(body)
# Loading work.addressable_memory(rtl)
add wave -position end  sim:/addressable_memory/WORD_SIZE
add wave -position end  sim:/addressable_memory/MEM_SIZE
add wave -position end  sim:/addressable_memory/clk
add wave -position end  sim:/addressable_memory/reset
add wave -position end  sim:/addressable_memory/write_en
add wave -position end  sim:/addressable_memory/mode
add wave -position end  sim:/addressable_memory/word_addr
add wave -position end  sim:/addressable_memory/data_in
add wave -position end  sim:/addressable_memory/data_out
add wave -position end  sim:/addressable_memory/memory
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: h4z3m  Hostname: LAPTOP-FNO6L2D9  ProcessID: 13220
#           Attempting to use alternate WLF file "./wlft7q5t77".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlft7q5t77
force -freeze sim:/addressable_memory/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/addressable_memory/reset 1 0
force -freeze sim:/addressable_memory/write_en 0 0
force -freeze sim:/addressable_memory/mode 0 0
force -freeze sim:/addressable_memory/word_addr 0 0
force -freeze sim:/addressable_memory/data_in 0 0
run
run
force -freeze sim:/addressable_memory/reset 0 0
force -freeze sim:/addressable_memory/write_en 1 0
force -freeze sim:/addressable_memory/mode 0 0
force -freeze sim:/addressable_memory/word_addr f 0
force -freeze sim:/addressable_memory/data_in abcd1234 0
run
force -freeze sim:/addressable_memory/mode 1 0
force -freeze sim:/addressable_memory/word_addr 002 0
run
# Compile of addressable_memory.vhd was successful.
restart
# ** Note: (vsim-12125) Error and warning message counts have been reset to '0' because of 'restart'.
# Loading work.addressable_memory(rtl)
force -freeze sim:/addressable_memory/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/addressable_memory/reset 1 0
force -freeze sim:/addressable_memory/write_en 0 0
force -freeze sim:/addressable_memory/mode 0 0
force -freeze sim:/addressable_memory/word_addr 0 0
force -freeze sim:/addressable_memory/data_in 0 0
run
run
force -freeze sim:/addressable_memory/reset 0 0
force -freeze sim:/addressable_memory/write_en 1 0
force -freeze sim:/addressable_memory/mode 0 0
force -freeze sim:/addressable_memory/word_addr f 0
force -freeze sim:/addressable_memory/data_in abcd1234 0
run
force -freeze sim:/addressable_memory/mode 1 0
force -freeze sim:/addressable_memory/word_addr 002 0
# Ctrl+D  ==>  Add to Dataflow
# Ctrl+W  ==>  Add to Wave
# Ctrl+D  ==>  Add to Dataflow
# Ctrl+W  ==>  Add to Wave
force -freeze sim:/addressable_memory/mode 1 0
force -freeze sim:/addressable_memory/word_addr 001 0
run
force -freeze sim:/addressable_memory/word_addr fa 0
run
force -freeze sim:/addressable_memory/write_en 0 0
run
run
run
force -freeze sim:/addressable_memory/mode 0 0
force -freeze sim:/addressable_memory/write_en 1 0
force -freeze sim:/addressable_memory/word_addr 10 0
force -freeze sim:/addressable_memory/data_in 80804040 0
run
force -freeze sim:/addressable_memory/write_en 0 0
run
run
force -freeze sim:/addressable_memory/mode 1 0
run
run
force -freeze sim:/addressable_memory/word_addr 0f 0
run
run
run
force -freeze sim:/addressable_memory/mode 0 0
run
run
force -freeze sim:/addressable_memory/word_addr 010 0
run
force -freeze sim:/addressable_memory/mode 1 0
run
force -freeze sim:/addressable_memory/word_addr 0f 0
run