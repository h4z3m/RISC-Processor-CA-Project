vsim -gui work.risc_cpu

add wave -position end  sim:/risc_cpu/clk
add wave -position end  sim:/risc_cpu/reset
add wave -position end  sim:/risc_cpu/in_port
add wave -position end  sim:/risc_cpu/out_port
add wave -position end  sim:/risc_cpu/INPUT_PORT_VALUE
add wave -position end  sim:/risc_cpu/ProgramCounter_Updated
add wave -position end  sim:/risc_cpu/ProgramCounter_Current
add wave -position end  sim:/risc_cpu/StackPointer_Updated
add wave -position end  sim:/risc_cpu/StackPointer_Current
add wave -position end  sim:/risc_cpu/DataMemory_ReadData
add wave -position end  sim:/risc_cpu/decode_stage_inst/RegFile/Regs
add wave -position end  sim:/risc_cpu/execute_stage_inst/FlagRegisterValue
mem load -i {C:/Users/h4z3m/Desktop/Files/College/3rd/2nd Semester/CMPN301/Project/data_mem.mem} /risc_cpu/memory2_stage_inst/Data_Memory/ram
mem load -i {C:/Users/h4z3m/Desktop/Files/College/3rd/2nd Semester/CMPN301/Project/inst_mem.mem} /risc_cpu/Instruction_Memory/ram
force -freeze sim:/risc_cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/risc_cpu/reset 1 0
force -freeze sim:/risc_cpu/in_port 0 0
force -freeze sim:/risc_cpu/in_port fffe 0
add log -r sim:/risc_cpu/*
run 1000ps
force -freeze sim:/risc_cpu/reset 0 0
run 4800ps 
force -freeze sim:/risc_cpu/in_port 0001 0
run 500ps 
force -freeze sim:/risc_cpu/in_port 000f 0
run 500ps 
force -freeze sim:/risc_cpu/in_port 00c8 0
run 500ps 
force -freeze sim:/risc_cpu/in_port 001f 0
run 500ps 
force -freeze sim:/risc_cpu/in_port 00fc 0
run 300ps