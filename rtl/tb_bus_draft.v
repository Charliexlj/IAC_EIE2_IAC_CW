module tb2 (
);
    /* Standard signals */
    logic clk;
    logic reset;
    logic active;
    logic[31:0] register_v0;

    /* Avalon memory mapped bus controller (master) */
    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    logic[31:0] check;
    logic[3:0] state;

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

        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        waitrequest = 0;
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");

        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");

        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        $display("readdata");
        readdata = 32'hac010008;
        //reg1 = reg4 + h20 = h0 + h20 = h20
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("writedata = %h",writedata);
        $display("");



        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        readdata = 32'b00100100000000110000000000100000;
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");



        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        readdata = 32'b00000000001000110001000000100001;
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");



        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        readdata = 32'b10000100010000100000101000000010;
        //100011 00010 00010 00000 10100 000000
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        readdata = 32'hbb00aa00;
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");

        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        readdata = 32'b10000000100000010000000010000000;
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        readdata = 32'b10100000010000100000101000000000;
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        //$display("check = %h",check);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        $display("writedata = %h",writedata);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");
        @(posedge clk);
        $display("state = %d",state);
        $display("read = %d",read);
        $display("write = %d",write);
        $display("byteenable = %b",byteenable);
        $display("writedata = %h",writedata);
        #1
        $display("register_v0 = %h",register_v0);
        $display("address = %h",address);
        $display("check = %h",check);
        $display("");








        $finish(0);





    end
    mips_cpu_bus h(
        clk,
        reset,
        active,
        register_v0,
        address,
        write,
        read,
        waitrequest,
        writedata,
        byteenable,
        readdata,
        check,
        state
        );
endmodule