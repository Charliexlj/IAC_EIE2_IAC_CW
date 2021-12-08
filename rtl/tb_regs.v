module tb_regs (
);
    logic clk;
    logic reset;
    logic[4:0] read_reg_1;
    logic[4:0] read_reg_2;
    logic[4:0] write_reg;
    logic[31:0] write_data;
    logic write_en;
    logic[31:0] read_data_1;
    logic[31:0] read_data_2;
    logic[31:0] register_v0;
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
        read_reg_1 = 5'd0;
        read_reg_2 = 5'd2;
        $display("reg0 : %h",read_data_1);
        $display("reg2 : %h",read_data_2);
        $display("register_v0 : %h",register_v0);
        #1
        clk = 0;
        #1
        clk = 1;
        write_en = 1;
        write_data = 32'h00008000;
        write_reg = 5'd5;
        #1
        clk = 0;
        #1
        clk = 1;
        write_en = 1;
        write_data = 32'h000a0000;
        write_reg = 5'd6;
        #1
        clk = 0;
        #1
        clk = 1;
        read_reg_1 = 5'd5;
        read_reg_2 = 5'd6;
        $display("reg5 : %h",read_data_1);
        $display("reg6 : %h",read_data_2);
        #1
        clk = 0;
        #1
        clk = 1;
        reset = 1;
        #1
        clk = 0;
        #1
        clk = 1;
        $display("reg5 : %h",read_data_1);
        $display("reg6 : %h",read_data_2);
    end
    mips_cpu_regs r(clk,reset,read_reg_1,read_reg_2,write_reg,write_data,write_en,read_data_1,read_data_2,register_v0);
endmodule