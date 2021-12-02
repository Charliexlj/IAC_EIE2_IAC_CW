module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

    always_ff @(posedge clk) begin
        if (reset) then begin
            /* Do reset logic */
            my_ff <= ... ;
        end
        else if(clk_enable) then
            /* Perform clock update */
            m_ff <= ... ;
        end
    end

endmodule