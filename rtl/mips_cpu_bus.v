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
    input logic[31:0] readdata,

    output logic[31:0] check,
    output logic[3:0] state_c
);
    assign state_c = state;
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

    logic[2:0] state;
    //_fetch_ pc give mem addr >> _decode_ memory give contents and control path decode it to different blocks
    // >> _execute_ 

    parameter FETCH = 3'd0;
    parameter DECODE = 3'd1;
    parameter EXECUTE = 3'd2;
    parameter MEM = 3'd3;
    parameter WRITEBACK = 3'd4;
    parameter HALT = 3'd5;

    assign register_v0 = reg_register_v0;

    //lw
    //fetch >> mem出来，address有了 >> datamem出来 >> register更新
                                                    //fetch

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
    logic byte_access;
    logic signed_byte;

    assign opcode = instr[31:26];
    assign branch_type = instr[20:16];

    //assign data_read = memread;
    //assign data_write = memwrite;  

    //reg
    logic[4:0] read_reg_1;
    logic[4:0] read_reg_2;
    logic[4:0] write_reg;
    logic[31:0] write_data;
    logic write_en;
    logic[31:0] read_data_1;
    logic[31:0] read_data_2;
    logic[31:0] reg_register_v0;
    
    assign read_reg_1 = instr[25:21];
    assign read_reg_2 = instr[20:16];
    assign write_reg = (link == 1) ? 5'b11111 : (regdst == 1) ? instr[15:11] : instr[20:16];
    //assign write_data = (mfhi == 1)? read_hi : (mflo == 1)? read_lo : (link == 1 || link_reg == 1) ? pc : (memtoreg == 1)? readdata : r;
    //assign write_en = (instr[31:26] == 6'b000000 && instr[5:0] == 6'b001000 )? 0 : regwrite;

    always @(*) begin
        if(opcode == 6'b100000) begin
            /*write_data <= (instr[1:0] == 2'b00)? {24'h0,readdata[31:24]} :
                        (instr[1:0] == 2'b01) ? {8'h0,readdata[23:16],16'h0} :
                        (instr[1:0] == 2'b10) ? {16'h0,readdata[15:8],8'h0} :
                        {24'h0,readdata[7:0]};*/
            if(instr[1:0] == 2'b00)begin
                write_data <= (readdata[31] == 1)? {24'hffffff,readdata[31:24]} : {24'h0,readdata[31:24]};
            end
            else if(instr[1:0] == 2'b01)begin
                write_data <= (readdata[23] == 1)? {24'hffffff,readdata[23:16]} : {24'h0,readdata[23:16]};
            end
            else if(instr[1:0] == 2'b10)begin
                write_data <= (readdata[15] == 1)? {24'hffffff,readdata[15:8]} : {24'h0,readdata[15:8]};
            end
            else begin
                write_data <= (readdata[7] == 1)? {24'hffffff,readdata[7:0]} : {24'h0,readdata[7:0]};
            end
        end
        else if (opcode == 6'b100100) begin
            if(instr[1:0] == 2'b00)begin
                write_data <= {24'h0,readdata[31:24]};
            end
            else if(instr[1:0] == 2'b01)begin
                write_data <= {24'h0,readdata[23:16]};
            end
            else if(instr[1:0] == 2'b10)begin
                write_data <= {24'h0,readdata[15:8]};
            end
            else begin
                write_data <= {24'h0,readdata[7:0]};
            end
        end
        else if (opcode == 6'b100001) begin
            if(instr[1]==1) begin
                write_data <= (readdata[15]==1)? {16'hffff,readdata[15:0]}:{16'h0,readdata[15:0]};
            end
            else begin
                write_data <= (readdata[31]==1)? {16'hffff,readdata[31:16]}:{16'h0,readdata[31:16]};
            end
        end
        else if(opcode == 6'b100101) begin
            if(instr[1]==1) begin
                write_data <= {16'h0,readdata[15:0]};
            end
            else begin
                write_data <= {16'h0,readdata[31:16]};
            end
        end
        else begin
            write_data <= (mfhi == 1)? read_hi : (mflo == 1)? read_lo : (link == 1 || link_reg == 1) ? pc : (memtoreg == 1)? readdata : r;;
        end
    end
    
    //assign writedata = read_data_2;

    always @(*) begin
        if(opcode == 6'b101000) begin
            writedata <= (instr[1:0] == 2'b00)? {read_data_2[31:24],24'h0} :
                        (instr[1:0] == 2'b01) ? {8'h0,read_data_2[23:16],16'h0} :
                        (instr[1:0] == 2'b10) ? {16'h0,read_data_2[15:8],8'h0} :
                        {24'h0,read_data_2[7:0]};
        end
        else if (opcode == 6'b101001) begin
            writedata <= (instr[1] == 1) ? {16'h0,read_data_2[15:0]} : {read_data_2[31:16],16'h0};
        end
        else begin
            writedata <= read_data_2;
        end
    end

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
                    (signed_data == 0) ? ({16'b0,instr[15:0]}) : 
                    (instr[15] == 1) ? ({16'hffff,instr[15:0]}) : 
                    ({16'b0,instr[15:0]});
                    
    assign fn = instr[5:0];
    assign sa = instr[10:6];
    assign alu_aluop = ctrl_aluop;

    assign check = {31'b0,write_en};

    //assign data_address = r;

    //pc
    logic[25:0] j_instr_addr;
    logic[15:0] i_instr_addr;
    logic[31:0] reg_addr;
    logic pc_branch;
    logic pc_jump;
    logic pc_jump_reg;
    logic pc_branch_con;
    logic[31:0] pc;

    
    assign j_instr_addr = instr[25:0];
    assign i_instr_addr = instr[15:0];
    assign reg_addr = read_data_1;

    //assign instr_address = pc;//NEED DIFFERENT CYCLES
    

    logic[31:0] data_hi, data_lo;
    logic hilo_hi_en, hilo_lo_en;
    logic[31:0] read_hi, read_lo;

    
    assign data_hi = r;
    assign data_lo = r_lo;
    /*
    assign hilo_hi_en = alu_hi_en;
    assign hilo_lo_en = alu_lo_en;
    */

    logic[31:0] pc_next;
    logic[27:0] j_instr_addr_s2;
    assign j_instr_addr_s2 = {j_instr_addr,2'b00};
    logic[31:0] i_instr_addr_se;
    assign i_instr_addr_se = {16'b0,i_instr_addr};

    /*
    always @(state == DECODE) begin
        //instr <= readdata;
        //write_en <= (instr[31:26] == 6'b000000 && instr[5:0] == 6'b001000 )? 0 : regwrite;
        hilo_hi_en <= alu_hi_en;
        hilo_lo_en <= alu_lo_en;
        //pc_jump <= ctrl_jump;
        //pc_branch <= ctrl_branch;
        //pc_branch_con <= alu_branch_con;
        //pc_jump_reg <= alu_jump_reg;
    end
    */

    assign write_en = (instr[31:26] == 6'b000000 && instr[5:0] == 6'b001000 )? 0 : regwrite;
    assign hilo_hi_en = alu_hi_en;
    assign hilo_lo_en = alu_lo_en;

    always @(*)begin
        pc_next <=  (reset == 1) ? 32'hbfc00000 :
                    (alu_jump_reg == 1 ) ? reg_addr :
                    (ctrl_jump == 1) ? {pc[31:28],j_instr_addr_s2} :
                    (ctrl_branch == 1 & alu_branch_con == 1) ? (pc + i_instr_addr_se) :
                    (pc + 32'd4);
    end

    logic[31:0] instr;
    assign instr = (state == EXECUTE) ? readdata : hold_instr;
    //assign writedata = read_data_2;
    logic[31:0] hold_instr;

    always_ff @(posedge clk) begin
        if (state == EXECUTE) begin
            hold_instr <= readdata;
        end
    end

    always_ff @(posedge clk or negedge reset) begin
        if(reset == 1) begin
            pc <= 32'hbfc00000;
            pc_branch <= 0;
            pc_jump <= 0;
            pc_jump_reg <= 0;
            pc_branch_con <= 0;
            //data_1 <= 0;
            //data_2 <= 0;
            hold_instr <= 0;
            active <= 1;
            byteenable <= 4'b1111;
            state <= FETCH;
        end
        else begin
            case (state)
                FETCH: begin
                    if (pc == 32'b0) begin
                        state <= HALT;
                    end
                    else if (waitrequest == 0) begin
                        address <= {pc[31:2],2'b0};
                        read <= 1;
                        write <= 0;
                        byteenable <= 4'hf;
                        state <= DECODE;
                    end
                    else begin
                        state <= FETCH;
                    end
                end
                DECODE: begin
                    read <= 0;
                    //instr <= readdata;
                    state <= EXECUTE;
                    //write_en <= (instr[31:26] == 6'b000000 && instr[5:0] == 6'b001000 )? 0 : regwrite;
                end
                EXECUTE: begin
                    //instr <= readdata;
                    if (memread == 1 || memwrite == 1) begin
                        address <= {r[31:2],2'b0};
                        if(byte_access == 1) begin
                            /*
                            byteenable <= (opcode == 6'b100000 || opcode == 6'b100100 || opcode == 6'b100001 || opcode == 6'b100101 || opcode == 6'b101000 || opcode == 6'b101001)?
                                            ((opcode == 6'b100001 || opcode == 6'b100101 || opcode == 6'b101001)? ((r[1] == 0)? 4'b0011 : 4'b1100)) :
                                            (r[1:0] == 2'b00)? 4'b1000:
                                            (r[1:0] == 2'b01)? 4'b0100:
                                            (r[1:0] == 2'b10)? 4'b0010:
                                            4'b0001;*/
                            if (opcode == 6'b100000 || opcode == 6'b100100 || opcode == 6'b100001 || opcode == 6'b100101 || opcode == 6'b101000 || opcode == 6'b101001) begin
                                if (opcode == 6'b100001 || opcode == 6'b100101 || opcode == 6'b101001) begin
                                    if (r[1] == 0) begin
                                        byteenable <= 4'b1100;
                                    end
                                    else begin
                                        byteenable <= 4'b0011;
                                    end
                                end
                                else begin
                                    if (r[1:0] == 2'b00) begin
                                        byteenable <= 4'b0001;
                                    end
                                    else if (r[1:0] == 2'b01) begin
                                        byteenable <= 4'b0010;
                                    end
                                    else if (r[1:0] == 2'b10) begin
                                        byteenable <= 4'b0100;
                                    end
                                    else begin
                                        byteenable <= 4'b1000;
                                    end
                                end
                            end
                        end
                        if (memread == 1) begin
                            read <= 1;
                        end
                        else begin
                            write <= 1;
                        end
                        state <= MEM;
                    end
                    else begin
                        pc <= pc_next;
                        state <= FETCH;
                    end
                end
                MEM: begin
                    if(waitrequest == 1) begin
                        state <= MEM;
                    end
                    else begin
                        //address <= r;
                        //read <= memread;
                        //write <= memwrite;
                        //writedata <= read_data_2;
                        if (write_en == 1 || write == 1) begin
                            state <= WRITEBACK;
                        end
                        else begin
                            pc <= pc_next;
                            state <= FETCH;
                        end
                    end
                end
                WRITEBACK: begin
                    pc <= pc_next;
                    state <= FETCH;
                end
                HALT: begin
                    active <= 0;
                end
                //default: begin
                    //$fatal(0,"unexpected state");
                //end
            endcase
        end
    end

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
        .signed_data(signed_data),
        .byte_access(byte_access),
        .signed_byte(signed_byte)
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
    /*
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
    */
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