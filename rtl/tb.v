module tb (
);
    logic clk;
    logic[4:0] a;
    logic[4:0] b;
    logic sel;
    logic[4:0] r;
    initial begin
        a=10;
        b=0;
        sel=0;
        #1
        assert(r==10);
        $display("r = %d",r);
        sel=1;
        #1
        assert(r==0);
        $display("r = %d",r);
    end
    mux5 m(a,b,sel,r);
endmodule