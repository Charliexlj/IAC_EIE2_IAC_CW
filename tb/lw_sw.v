module lw_sw (
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
        instr_readdata = 32'b00100100000000101010000000000000;
        //001001 00000 00010 10100 00000 000000
        //reg2 = a000

        @(negedge clk);
        $display("c1 instr_address = %h",instr_address);

        @(posedge clk);
        instr_readdata = 32'b10101100010000100000101000000000;
        
        //101011 00010 00010 00001 01000 000000
        //sw mem[aa00] = reg2

        @(negedge clk);
        $display("c2 instr_address = %h",instr_address);
        $display("c2 register_v0 = %h",register_v0);
        $display("c2 data_address = %h",data_address);
        $display("c2 data_write = %h",data_write);
        $display("c2 data_writedata = %h",data_writedata);

        @(posedge clk);
        instr_readdata = 32'b10001100010000100000101000000000;
        data_readdata = 32'hcc000000;
        //100011 00010 00010 00001 01000 000000
        //lw reg2 = mem[reg2 + a] = 32'hcc000000

        @(negedge clk);
        $display("c3 instr_address = %h",instr_address);
        $display("c3 data_address = %h",data_address);
        $display("c3 data_read = %h",data_read);
        $display("c3 data_readdata = %h",data_readdata);
        //assert(instr_address == 32'hc0000000) else $fatal(1);

        @(negedge clk);
        $display("c4 instr_address = %h",instr_address);
        $display("c4 register_v0 = %h",register_v0);
        $display("LW_SW Pass");
        $finish(0);
    end
    mips_cpu_harvard h(clk,reset,active,register_v0,clk_enable,instr_address,instr_readdata,data_address,data_write,data_read,data_writedata,data_readdata);
endmodule