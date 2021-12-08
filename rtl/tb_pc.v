module tb_pc (
);
    logic clk;
    logic reset;
    logic[25:0] j_instr_addr;
    logic[15:0] i_instr_addr;
    logic[31:0] reg_addr;
    logic branch;
    logic jump;
    logic jump_reg;
    logic branch_con;
    logic[31:0] pc;

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
        branch = 0;
        jump = 0;
        jump_reg = 0;
        branch_con = 0;
        clk = 0;
        #1
        clk = 1;
        #1
        $display("pc : %h",pc);
        clk = 0;
        #1
        clk = 1;
        branch = 1;
        #1
        $display("pc : %h",pc);
        #1
        clk = 0;
        #1
        clk = 1;
        branch_con = 1;
        i_instr_addr = 16'h0080;
        #1
        $display("pc : %h",pc);
        clk = 0;
        #1
        clk = 1;
        branch = 0;
        branch_con = 0;
        #1
        $display("pc : %h",pc);
        clk = 0;
        #1
        clk = 1;
        jump = 1;
        j_instr_addr = 26'b0000000000000000000101000;
        #1
        $display("pc : %h",pc);
        #1
        clk = 0;
        #1
        clk = 1;
        jump = 0;
        #1
        $display("pc : %h",pc);
        #1
        clk = 0;
        #1
        clk = 1;
        jump_reg = 1;
        reg_addr = 32'h0000a000;
        #1
        $display("pc : %h",pc);
        clk = 0;
        #1
        clk = 1;
        jump_reg = 0;
        #1
        $display("pc : %h",pc);
        clk = 0;
        #1
        clk = 1;

        #1
        $display("pc : %h",pc);
        #1
        clk = 0;
        #1
        clk = 1;
        reset = 1;
        #1
        $display("pc : %h",pc);
        #1
        clk = 0;
        #1
        clk = 1;
        reset = 0;
        #1
        $display("pc after reset 0: %h",pc);
        clk = 0;
        #1
        clk = 1;

        #1
        $display("pc : %h",pc);
        clk = 0;
        #1
        clk = 1;

        #1
        $display("pc : %h",pc);
        #1
        clk = 0;
        #1
        clk = 1;

        #1
        $display("pc : %h",pc);
        #1
        clk = 0;
        #1
        clk = 1;

        #1
        $display("pc : %h",pc);
        clk = 0;
        #1
        clk = 1;

        #1
        $display("pc : %h",pc);
        clk = 0;
        #1
        clk = 1;

        #1
        $display("pc : %h",pc);
        #1
        clk = 0;
        #1
        clk = 1;
        #1
        $display("pc : %h",pc);
    end
    mips_cpu_pc p(clk,reset,j_instr_addr,i_instr_addr,reg_addr,branch,jump,jump_reg,branch_con,pc);
endmodule