module jr_jalr (
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
        instr_readdata = 32'b10001100000000100000000000000000;
        data_readdata = 32'hc0000000;
        //100011 00000 00010 00000 00000 000000
        //lw reg2 = mem[reg0 + 0] = 32'hc0000000

        @(negedge clk);
        $display("c1 instr_address = %h",instr_address);

        @(posedge clk);
        instr_readdata = 32'b00000000010000000000000000001000;
        //000000 00010 00000 00000 00000 001000
        //jr reg2 = c0000000

        @(negedge clk);
        $display("c2 instr_address = %h",instr_address);
        $display("c2 register_v0 = %h",register_v0);

        @(posedge clk);
        instr_readdata = 32'b10001100000000100000000000000000;
        data_readdata = 32'hd0000000;
        //100011 00000 00010 00000 00000 000000
        //lw reg2 = mem[reg0 + 0] = 32'hd0000000

        @(negedge clk);
        $display("c3 instr_address = %h",instr_address);
        assert(instr_addres == 32'hc0000000) else $fatal(1);

        @(posedge clk);
        instr_readdata = 32'b00000000010000000001100000001001;
        //000000 00010 00000 00011 00000 001001
        //jalr reg2 = d0000000; reg3 = pc = c0000000

        @(negedge clk);
        $display("c4 instr_address = %h",instr_address);
        $display("c4 register_v0 = %h",register_v0);

        @(posedge clk);
        instr_readdata = 32'b00000000011000000001000000100001;
        //000000 00011 00000 00010 00000 100001
        //reg2 = reg3

        @(negedge clk);
        $display("c5 instr_address = %h",instr_address);
        assert(instr_address == 32'hd0000000) else $fatal(1);
        $display("c5 reg_v0 = %h",register_v0);

        /*@(posedge clk);
        instr_readdata = 32'b00000000000000000001000000010000;
        //000000 00000 00000 00010 00000 010000
        //move from hi to reg2*/

        @(negedge clk);
        $display("c6 instr_address = %h",instr_address);
        $display("c6 reg_v0 = %h",register_v0);
        assert(register_v0 == 32'hc0000004) else $fatal(1);

        /*@(posedge clk);
        instr_readdata = 32'b00000000000000000001000000010010;
        //000000 00000 00000 00010 00000 010010
        //move from hi to reg2

        @(negedge clk);
        $display("c5 instr_address = %h",instr_address);
        $display("c5 reg_v0 = %h",register_v0);
        //assert(register_v0 == 1) else $fatal(0);

        @(negedge clk);
        $display("c6 instr_address = %h",instr_address);
        $display("c6 reg_v0 = %h",register_v0);
        //assert(register_v0 == 2) else $fatal(0);*/
        $display("JR_JALR Pass");
        $finish(0);
    end
    mips_cpu_harvard h(clk,reset,active,register_v0,clk_enable,instr_address,instr_readdata,data_address,data_write,data_read,data_writedata,data_readdata);
endmodule