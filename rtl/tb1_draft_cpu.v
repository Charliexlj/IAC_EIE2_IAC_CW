module tb1 (
);
        /* Standard signals */
    logic     clk;
    logic     reset;
    logic    active;
    logic [31:0] register_v0;

    /* New clock enable. See below. */
    logic     clk_enable;

    /* Combinatorial read access to instructions */
    logic[31:0]  instr_address;
    logic[31:0]   instr_readdata;

    /* Combinatorial read and single-cycle write access to instructions */
    logic[31:0]  data_address;
    logic        data_write;
    logic        data_read;
    logic[31:0]  data_writedata;
    logic[31:0]  data_readdata;

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
        instr_readdata = 32'b00100100100000010000000000100000;
        //001001 00100 00001 00000 00000 100000
        //reg1 = reg4 + h20 = h0 + h20 = h20
        #1
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00100100001000110000000000100000;
        //001001 00001 00011 00000 00000 100000
        //reg3 = reg1 + h20 = h20 + h20 = h40
        #1
        $display("reg_v0 = %h",register_v0);
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00000000001000110010000000100001;
        //000000 00001 00011 00100 00000 100001
        //reg4 = reg1 + reg3 = h20 + h40 = h60
        #1
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b10001100100000100000000010000000;
        //100011 00100 00010 00000 00010 000000
        //lw reg2 = h80 + h60 = he0
        data_readdata = 32'hc0000000;
        #1
        $display("data_address : %h",data_address);
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00000000010000000000000000001000;
        //000000 00010 00000 00000 00000 001000
        //jump reg2 = c0000000
        #1
        $display("reg_v0 = %h",register_v0);
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b10101100010000110000000010000000;
        //101011 00010 00011 00000 00010 000000
        //sw mem[c0000000+80] = reg3
        #1
        $display("instr_address = %h",instr_address);
        $display("data write = %h",data_write);
        $display("data writedata = %h",data_writedata);
        $display("data addr = %h",data_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00010000001000110000000010000000;
        //000101 00001 00011 00000 00010 000000
        //bne to c0000084
        #1
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00001000000000000000000010000000;
        //000010 00000 00000 00000 00010 000000
        //jump to c000400
        #1
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00000000011000000000000000010001;
        //000000 00001 00000 00000 00000 010001
        //mthi
        #1
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00000000000000000001000000010000;
        //000000 00000 00000 00010 00000 010000
        //mfhi
        #1
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00000000001000110000000000011001;
        //000000 00001 00011 00000 00000 011001
        //reg1 * reg3
        #1
        $display("reg_v0 = %h",register_v0);
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        instr_readdata = 32'b00000000000000000001000000010010;
        //000000 00000 00000 00010 00000 010000
        //mflo
        #1
        $display("instr_address = %h",instr_address);
        clk = 0;
        #1
        clk = 1;
        #1
        $display("reg_v0 = %h",register_v0);
        $display("instr_address = %h",instr_address);
        
    end
    mips_cpu_harvard h(clk,reset,active,register_v0,clk_enable,instr_address,instr_readdata,data_address,data_write,data_read,data_writedata,data_readdata);
endmodule