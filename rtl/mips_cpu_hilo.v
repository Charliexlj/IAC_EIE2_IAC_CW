module mips_cpu_hilo (
    input logic clk,
    input logic reset,
    input logic[31:0] data_hi, data_lo,
    input logic hi_en, lo_en,
    output logic[31:0] read_hi, read_lo
);
    logic[31:0] hi;
    logic[31:0] lo;
    assign read_hi = hi;
    assign read_lo = lo;
    always_ff @(posedge clk) begin
        hi <= (reset == 1) ? 32'b0 : (hi_en == 1) ? data_hi : hi;
        lo <= (reset == 1) ? 32'b0 : (lo_en == 1) ? data_lo : lo;
    end
    
endmodule