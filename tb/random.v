module random (
);
    logic[15:0] a;
    logic[15:0] b;
    logic[15:0] r;
    logic[15:0] v;
    initial begin
        a = 16'hfff0;
        b = 16'h4;
        r = $signed(a)/$signed(b);
        $display("r = %d",$signed(r));
    end
endmodule