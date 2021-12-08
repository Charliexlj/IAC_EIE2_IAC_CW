module tb_alu (
);
    logic[31:0] data_1;
    logic[31:0] data_2;
    logic[5:0] fn;
    logic[3:0] aluop;
    logic[31:0] r;
    logic[31:0] r_lo;
    logic hi_en, lo_en;
    logic mfhi, mflo;
    logic branch_con;
    logic jump_reg;

    initial begin
        data_1 = 32'h000a0000;
        data_2 = 32'h00008000;
        fn = 6'b011001;
        aluop = 4'b0000;
        #1
        $display("r = %h",r);
        $display("r_lo = %h",r_lo);
        $display("hi_en = %h",hi_en);
    end

    mips_cpu_alu a(data_1,data_2,fn,aluop,r,r_lo,hi_en,lo_en,mfhi,mflo,branch_con,jump_reg);

endmodule