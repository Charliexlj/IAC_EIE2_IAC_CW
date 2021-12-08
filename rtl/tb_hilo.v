module tb_hilo (
);
    logic clk;
    logic reset;
    logic[31:0] data_hi, data_lo;
    logic hi_en, lo_en;
    logic[31:0] read_hi, read_lo;

    initial begin
        clk = 0;
        #1
        clk = 1;
        reset = 1;
        #1
        clk = 0;
        #1
        clk = 1;
        reset = 0;
        data_hi = 32'd100;
        data_lo = 32'd200;
        hi_en = 1;
        lo_en = 1;
        clk = 0;
        #1
        clk = 1;
        hi_en = 0;
        lo_en = 0;
        #1
        clk = 0;
        #1
        clk = 1;
        #1
        $display("hi: %d",read_hi);
        $display("lo: %d",read_lo);
    end
    mips_cpu_hilo hilo(clk,reset,data_hi,data_lo,hi_en,lo_en,read_hi,read_lo);
endmodule