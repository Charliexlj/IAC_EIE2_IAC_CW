/*  Implements a 16-bit x 4K RAM, with single-cycle register read.
    This is synthesisable, and should turn into block-ram.
*/
module mips_cpu_ram(
    input logic clk,
    input logic[31:0] address,
    input logic write,
    input logic read,
    input logic[31:0] writedata,
    output logic[31:0] readdata,
    input logic[3:0] byteenable,
    output logic waitrequest
);
    parameter RAM_INIT_FILE = "";

    reg [7:0] memory [17179869184:0];

    initial begin
        waitrequest == 0;
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<(17179869184); i++) begin
            memory[i]=0;
        end
        
        /* Load contents from file if specified */
        /*
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end
        */
    end

    /* Synchronous write path */
    always @(posedge clk) begin
        //$display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
        if (write) begin
            if (byteenable[3] == 1) begin
                memory[address] <= writedata[31:24];
            end
            if (byteenable[2] == 1) begin
                memory[address+1] <= writedata[23:16];
            end
            if (byteenable[1] == 1) begin
                memory[address+2] <= writedata[15:8];
            end
            if (byteenable[0] == 1) begin
                memory[address+3] <= writedata[7:0];
            end
        end
        if(byteenable[3] == 1) begin
            readdata[31:24] <= memory[address];
        end
        if(byteenable[2] == 1) begin
            readdata[23:16] <= memory[address+1];
        end
        if(byteenable[1] == 1) begin
            readdata[15:8] <= memory[address+2];
        end
        if(byteenable[3] == 1) begin
            readdata[7:0] <= memory[address+3];
        end
        //readdata <= memory[address]; // Read-after-write mode
    end
endmodule