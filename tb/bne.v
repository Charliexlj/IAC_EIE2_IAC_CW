module bne (
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

    // Generate clock
    parameter TIMEOUT_CYCLES = 10000;
    initial begin
        clk=0;

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin
        reset <= 0;

        @(posedge clk);
        reset <= 1;

        @(posedge clk);
        reset <= 0;
        /*instr*/
        instr_readdata = 32'b00100100000000010000000000100000;
        //001001 00000 00001 00000 00000 100000
        //reg1 = reg0 + 20 = 0 + 20 = 20

        @(negedge clk);
        $display("c1 instr_address = %h",instr_address);

        @(posedge clk);
        instr_readdata = 32'b00100100000000110000000000100000;
        //001001 00010 00000 00000 00000 100000
        //reg3 = reg0 + 20 = 0 + 20 = 20

        @(negedge clk);
        $display("c2 instr_address = %h",instr_address);

        @(posedge clk);
        instr_readdata = 32'b00010100011000000000000010000000;
        //000100 00011 00000 00000 00010 000000
        //branch if reg0 != reg3 (true), to bfc00008 + 20 = bfc00088

        @(negedge clk);
        $display("c3 instr_address = %h",instr_address);

        @(posedge clk);
        instr_readdata = 32'b00010100011000010000000010000000;
        //000100 00011 00001 00000 00010 000000
        //branch if reg1 != reg3 (false), no branch, next instr = bfc0008c

        @(negedge clk);
        $display("c4 instr_address = %h",instr_address);
        assert(instr_address == 32'hbfc00088) else $fatal(1,"Fail");

        @(negedge clk);
        $display("c5 instr_address = %h",instr_address);
        assert(instr_address == 32'hbfc0008c) else $fatal(1,"Fail");
        $display("BNE Pass");
        $finish(0);
    end
    mips_cpu_harvard h(clk,reset,active,register_v0,clk_enable,instr_address,instr_readdata,data_address,data_write,data_read,data_writedata,data_readdata);
endmodule