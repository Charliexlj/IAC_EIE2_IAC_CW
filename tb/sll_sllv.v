module sll_sllv (
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
        instr_readdata = 32'b00100100001000110000000000001010;
        //001001 00001 00011 00000 00000 001010
        //reg3 = reg1 + a = 0 + a = a

        @(negedge clk);

        $display("c1 instr_address = %h",instr_address);
        $display("c1 reg_v0 = %h",register_v0);

        @(posedge clk);
        instr_readdata = 32'b00100100011000010000000000000110;
        //001001 00011 00001 00000 00000 000110
        //reg1 = reg3 + 6 = a + 6 = 10

        @(negedge clk);
        $display("c2 instr_address = %h",instr_address);
        $display("c2 reg_v0 = %h",register_v0);

        @(posedge clk);
        instr_readdata = 32'b00000000000000010001000010000000;
        //000000 00000 00001 00010 00010 000000
        //10<<2

        @(negedge clk);
        $display("c3 instr_address = %h",instr_address);
        $display("c3 reg_v0 = %h",register_v0);

        @(posedge clk);
        instr_readdata = 32'b00000000011000010001000000000100;
        //000000 00011 00001 00010 00000 000100
        //10<<10

        @(negedge clk);
        $display("c4 instr_address = %h",instr_address);
        $display("c4 reg_v0 = %h",register_v0);
        assert(register_v0 == 32'h40) else $fatal(1,"Fail");

        @(negedge clk);
        $display("c5 instr_address = %h",instr_address);
        $display("c5 reg_v0 = %h",register_v0);
        assert(register_v0 == 32'h4000) else $fatal(1,"Fail");
        $display("SLL_SLLV Pass");
        $finish(0);
    end
    mips_cpu_harvard h(clk,reset,active,register_v0,clk_enable,instr_address,instr_readdata,data_address,data_write,data_read,data_writedata,data_readdata);
endmodule