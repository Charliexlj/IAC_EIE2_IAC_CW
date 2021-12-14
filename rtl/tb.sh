iverilog -Wall -g 2012 -s tb2 -o tb2 tb_bus_draft.v mips_cpu_bus.v mips_cpu_alu.v mips_cpu_regs.v mips_cpu_control.v mips_cpu_hilo.v
./tb2