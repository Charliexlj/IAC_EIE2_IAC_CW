module mux5 (
    input logic[4:0] data_0,
    input logic[4:0] data_1,
    input logic sel,
    output logic[4:0] r
);
    always_comb begin
        r = (sel == 1) ? data_1 : data_0;
    end
endmodule