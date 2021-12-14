module mips_cpu_bus_tb;
    timeunit 1ns / 10ps;

    parameter RAM_INIT_FILE = " ";
    parameter TIMEOUT_CYCLES = 10000;

    logic clk;
    logic reset;

    logic active;

    logic[31:0] register_v0;

    logic[31:0] address;
    logic write;
    logic read;
    logic[31:0] writedata;
    logic[31:0] readdata;
    logic[3:0] byteenable;
    logic waitrequest;
    logic[31:0] check;
    logic[3:0] state_c;

    /*#(RAM_INIT_FILE)*/
    mips_cpu_ram #(RAM_INIT_FILE) ramInst(clk, address, write, read, writedata, readdata, byteenable, waitrequest);
    
    mips_cpu_bus cpuInst(clk, reset, active, register_v0, address, write, read, waitrequest, writedata, byteenable, readdata);

    // Generate clock
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

        @(posedge clk);
        assert(active==1)
        else $display("TB : CPU did not set active=1 after reset.");

        while (active) begin
            @(posedge clk);
        end

        $display("TB : finished; active=0");
        $display("register_v0 = %h",register_v0);
        $finish;
        
    end

    

endmodule