module mips_cpu_pc (
    input logic clk,
    input logic reset,
    input logic[25:0] j_instr_addr,
    input logic[15:0] i_instr_addr,
    input logic[31:0] reg_addr,
    input logic branch,
    input logic jump,
    input logic jump_reg,
    input logic branch_con,
    output logic[31:0] pc
);
    logic[31:0] pc_next;
    logic[27:0] j_instr_addr_s2;
    assign j_instr_addr_s2 = {j_instr_addr,2'b00};
    logic[31:0] i_instr_addr_se;
    assign i_instr_addr_se = {16'b0,i_instr_addr};
    always @(*)begin
        pc_next <=  (reset == 1) ? 32'hbfc00000 :
                    (jump_reg == 1 ) ? reg_addr :
                    (jump == 1) ? {pc[31:28],j_instr_addr_s2} :
                    (branch == 1 & branch_con == 1) ? (pc + i_instr_addr_se) :
                    (pc + 32'd4);
    end

    always_ff @(posedge clk) begin
        pc <= pc_next;
    end
endmodule