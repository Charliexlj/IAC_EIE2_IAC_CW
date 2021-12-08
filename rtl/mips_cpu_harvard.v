module mips_cpu_harvard(
    /* Standard signals */
    input logic     clk,
    input logic     reset,
    output logic    active,
    output logic [31:0] register_v0,

    /* New clock enable. See below. */
    input logic     clk_enable,

    /* Combinatorial read access to instructions */
    output logic[31:0]  instr_address,
    input logic[31:0]   instr_readdata,

    /* Combinatorial read and single-cycle write access to instructions */
    output logic[31:0]  data_address,
    output logic        data_write,
    output logic        data_read,
    output logic[31:0]  data_writedata,
    input logic[31:0]  data_readdata

);
    /*
    always_ff @(posedge clk) begin
        if (reset) then begin
            / Do reset logic /
            my_ff <= ... ;
        end
        else if(clk_enable) then
            / Perform clock update /
            m_ff <= ... ;
        end
    end
    */

    assign register_v0 = reg_register_v0;


    //control
    logic[5:0] opcode;
    logic[4:0] branch_type;
    logic regdst;
    logic ctrl_branch;
    logic ctrl_jump;
    logic memread;
    logic memtoreg;
    logic[3:0] ctrl_aluop;
    logic memwrite;
    logic alusrc;
    logic regwrite;
    logic link;
    logic signed_data;

    assign opcode = instr_readdata[31:26];
    assign branch_type = instr_readdata[20:16];

    assign data_read = memread;
    assign data_write = memwrite;  

    //reg
    logic[4:0] read_reg_1;
    logic[4:0] read_reg_2;
    logic[4:0] write_reg;
    logic[31:0] write_data;
    logic write_en;
    logic[31:0] read_data_1;
    logic[31:0] read_data_2;
    logic[31:0] reg_register_v0;
    
    assign read_reg_1 = instr_readdata[25:21];
    assign read_reg_2 = instr_readdata[20:16];
    assign write_reg = (link == 1) ? 5'b11111 : (regdst == 1) ? instr_readdata[15:11] : instr_readdata[20:16];
    assign write_data = (mfhi == 1)? read_hi : (mflo == 1)? read_lo : (link == 1 || link_reg == 1) ? pc : (memtoreg == 1)? data_readdata : r;
    assign write_en = (instr_readdata[31:26] == 6'b000000 && instr_readdata[5:0] == 6'b001000 )? 0 : regwrite;
    
    assign data_writedata = read_data_2;

    //alu
    logic[31:0] data_1;
    logic[31:0] data_2;
    logic[5:0] fn;
    logic[4:0] sa;
    logic[3:0] alu_aluop;
    logic[31:0] r;
    logic[31:0] r_lo;
    logic alu_hi_en, alu_lo_en;
    logic mfhi, mflo;
    logic alu_branch_con;
    logic alu_jump_reg;
    logic link_reg;
    
    assign data_1 = read_data_1;
    assign data_2 = (alusrc == 0)? read_data_2 : 
                    (signed_data == 0) ? ({16'b0,instr_readdata[15:0]}) : 
                    (instr_readdata[15] == 1) ? ({16'hffff,instr_readdata[15:0]}) : 
                    ({16'b0,instr_readdata[15:0]});
    assign fn = instr_readdata[5:0];
    assign sa = instr_readdata[10:6];
    assign alu_aluop = ctrl_aluop;

    assign data_address = r;

    //pc
    logic[25:0] j_instr_addr;
    logic[15:0] i_instr_addr;
    logic[31:0] reg_addr;
    logic pc_branch;
    logic pc_jump;
    logic pc_jump_reg;
    logic pc_branch_con;
    logic[31:0] pc;
    
    assign j_instr_addr = instr_readdata[25:0];
    assign i_instr_addr = instr_readdata[15:0];
    assign reg_addr = read_data_1;
    assign pc_branch = (reset == 1) ? 0 : ctrl_branch;
    assign pc_jump = (reset == 1) ? 0 : ctrl_jump;
    assign pc_jump_reg = (reset == 1) ? 0 : alu_jump_reg;
    assign pc_branch_con = (reset == 1) ? 0 : alu_branch_con;

    assign instr_address = pc;

    logic[31:0] data_hi, data_lo;
    logic hilo_hi_en, hilo_lo_en;
    logic[31:0] read_hi, read_lo;

    assign data_hi = r;
    assign data_lo = r_lo;
    assign hilo_hi_en = alu_hi_en;
    assign hilo_lo_en = alu_lo_en;

    mips_cpu_control control(
        .opcode(opcode),
        .branch_type(branch_type),
        .regdst(regdst),
        .branch(ctrl_branch),
        .jump(ctrl_jump),
        .memread(memread),
        .memtoreg(memtoreg),
        .aluop(ctrl_aluop),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .regwrite(regwrite),
        .link(link),
        .signed_data(signed_data)
    );

    mips_cpu_regs regs(
        .clk(clk),
        .reset(reset),
        .read_reg_1(read_reg_1),
        .read_reg_2(read_reg_2),
        .write_reg(write_reg),
        .write_data(write_data),
        .write_en(write_en),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .register_v0(reg_register_v0)
    );

    mips_cpu_alu alu(
        .data_1(data_1),
        .data_2(data_2),
        .fn(fn),
        .sa(sa),
        .aluop(alu_aluop),
        .r(r),
        .r_lo(r_lo),
        .hi_en(alu_hi_en),
        .lo_en(alu_lo_en),
        .mfhi(mfhi),
        .mflo(mflo),
        .branch_con(alu_branch_con),
        .jump_reg(alu_jump_reg),
        .link_reg(link_reg)
    );

    mips_cpu_pc programc(
        .clk(clk),
        .reset(reset),
        .j_instr_addr(j_instr_addr),
        .i_instr_addr(i_instr_addr),
        .reg_addr(reg_addr),
        .branch(pc_branch),
        .jump(pc_jump),
        .jump_reg(pc_jump_reg),
        .branch_con(pc_branch_con),
        .pc(pc)
    );

    mips_cpu_hilo hilo(
        .clk(clk),
        .reset(reset),
        .data_hi(data_hi),
        .data_lo(data_lo),
        .hi_en(hilo_hi_en),
        .lo_en(hilo_lo_en),
        .read_hi(read_hi),
        .read_lo(read_lo)
    );

endmodule