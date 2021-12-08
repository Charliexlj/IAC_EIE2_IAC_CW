iverilog -Wall -g 2012 \
    -s sll_sllv \
    -o tb/r/sll_sllv \
    tb/sll_sllv.v \
    rtl/mips_cpu_harvard.v rtl/mips_cpu_alu.v rtl/mips_cpu_pc.v rtl/mips_cpu_regs.v rtl/mips_cpu_control.v rtl/mips_cpu_hilo.v
./tb/r/sll_sllv