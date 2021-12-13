#!/bin/bash
set -eou pipefail

iverilog -g 2012 \
   -s mips_cpu_bus_tb \
   -P mips_cpu_bus_tb.RAM_INIT_FILE=\"test1_addu.txt\" \
   -o mips_cpu_bus_tb_addu \
   mips_cpu_bus_tb.v mips_cpu_bus.v mips_cpu_ram.v mips_cpu_alu.v mips_cpu_regs.v mips_cpu_control.v mips_cpu_hilo.v