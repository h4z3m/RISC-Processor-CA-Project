vsim -gui work.risc_cpu
add wave -position end  sim:/risc_cpu/reset
add wave -position end  sim:/risc_cpu/clk
add wave -position end  sim:/risc_cpu/interrupt
add wave -position end  sim:/risc_cpu/ProgramCounter/D
add wave -position end  sim:/risc_cpu/decode_stage_inst/RegFile/Regs
add wave -position end  sim:/risc_cpu/execute_stage_inst/FlagRegister/Q
add wave -position end  sim:/risc_cpu/in_port
add wave -position end  sim:/risc_cpu/INPUT_PORT_VALUE
add wave -position end  sim:/risc_cpu/out_port
add wave -position end  sim:/risc_cpu/StackPointer/Q
add log -r sim:/risc_cpu/*
mem load -i {C:/Users/h4z3m/Desktop/Files/College/3rd/2nd Semester/CMPN301/Project/Assembler/data_hazards.mem} -startaddress 0 -endaddress 1023 -update_properties /risc_cpu/Instruction_Cache/memory
mem load -i {C:/Users/h4z3m/Desktop/Files/College/3rd/2nd Semester/CMPN301/Project/full_memory.mem} /risc_cpu/memory2_stage_inst/addressable_memory_inst/memory
force -freeze sim:/risc_cpu/reset 1 0
force -freeze sim:/risc_cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/risc_cpu/interrupt 0 0
force -freeze sim:/risc_cpu/in_port 44 0
run 950ps
force -freeze sim:/risc_cpu/reset 0 0
run 3000ps