module mips_cpu_regs (
    input logic clk,
    input logic reset,
    input logic[4:0] read_reg_1,
    input logic[4:0] read_reg_2,
    input logic[4:0] write_reg,
    input logic[31:0] write_data,
    input logic write_en,
    output logic[31:0] read_data_1,
    output logic[31:0] read_data_2,
    output logic[31:0] register_v0
);
    logic[31:0] regs[31:0];
    assign read_data_1 = regs[read_reg_1];
    assign read_data_2 = regs[read_reg_2];
    assign register_v0 = regs[2];
    integer i;
    always_ff @(posedge clk) begin
        if(reset == 1) begin
            for (i = 0; i<32; i=i+1) begin
                regs[i] <= 32'b0;
            end
        end
        else begin
            regs[write_reg] <= (write_en == 1)? write_data : regs[write_reg];
        end
    end
    
endmodule