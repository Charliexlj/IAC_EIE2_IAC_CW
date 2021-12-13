module mips_cpu_control (
    input logic[5:0] opcode,
    input logic[4:0] branch_type,
    output logic regdst,
    output logic branch,
    output logic jump,
    output logic memread,
    output logic memtoreg,
    output logic[3:0] aluop,
    output logic memwrite,
    output logic alusrc,
    output logic regwrite,
    output logic link,
    output logic signed_data,
    output logic byte_access,
    output logic signed_byte
);
    /*
    ---
    THIS VERSION BASE ON HARVARD ARCHITECTURE
    ---
    */

    always @(*) begin
        /*default "addu"
        addu rd = rs + rt
        opcode[31:26] rs[25:21] rt[20:16] rd[15:11] shift[10:6] fn[5:0]
        prevent undefine behaviour*/
        aluop <= 4'b0000;//rtype
        regdst <= 1'b1;//rd[15:11]
        branch <= 1'b0;//no branch
        jump <= 1'b0;//no jump
        memread <= 1'b0;//no need read from data memory
        memtoreg <= 1'b0;//alu_result to register
        memwrite <= 1'b0;//no write to memory
        alusrc <= 1'b0;//data from register
        regwrite <= 1'b1;//write to register
        link <= 1'b0;
        signed_data <= 1'b0;
        byte_access <= 1'b0;
        signed_byte <= 1'b0;
        /*
        other instructions
        i_type/j_type will need aluop
        ------------
        ↓ implemented r_type alu op ↓
        for r_type aluop will be 4'b0000
        ------------
        unsign addition         100001
        and                     100100
        or                      100101
        set on less than        101010
        set on less than u      101011
        unsign subtract         100011
        xor                     100110
        shift left logical      000000
        shift left logical var  000100
        shift right arithmetic  000011
        shift right arith var   000111
        shift right logical     000010
        shift right logical var 000110
        div                     011010
        divu                    011011
        move to HI              010001
        move to LO              010011
        multiply                011000
        unsign multiply         011001
        jump and link register  001001
        jump register           001000
        ------------
        ↓ need to add for other two types ↓
        ------------
        add                     0001
        and                     0010
        if a = b                0011
        if a > 0                0100
        if a >= 0               0101
        if a < 0                0110
        if a <= 0               0111
        if a != b               1000
        or                      1001
        slti                    1010
        sltiu                   1011
        */
        case (opcode)
            /*↓addiu↓*/
            6'b001001: begin
                //change back to 0001
                aluop <= 4'b0001;//unsign addition
                regdst <= 1'b0;//rd[20:16]
                alusrc <= 1'b1;//data from instruction
            end

            /*opcode of 6'b000000 same as addu*/

            /*↓andi↓*/
            6'b001100: begin
                aluop <= 4'b0010;//and
                regdst <= 1'b0;//rd[20:16]
                alusrc <= 1'b1;//data from instruction
                signed_data <= 1;
            end

            /*↓beq↓*/
            6'b000100: begin
                aluop <= 4'b0011;//a=b
                branch <= 1'b1;//if condition satisfied then branch
                regwrite <= 1'b0;
                signed_data <= 1;
            end
            
            /*↓bgez&bgezal↓*/
            /*↓bltz&bltzal↓*/
            6'b000001: begin
                case (branch_type)
                    5'b00001: begin
                        aluop <= 4'b0101;//a>=0
                        branch <= 1'b1;//if alu return 0 then branch
                        regwrite <= 1'b0;
                        signed_data <= 1;
                    end
                    5'b10001: begin
                        aluop <= 4'b0101;//a>=0
                        branch <= 1'b1;//if alu return 0 then branch
                        link <= 1'b1;
                        signed_data <= 1;
                    end
                    5'b00000: begin
                        aluop <= 4'b0110;//a<0
                        branch <= 1'b1;//if alu return 0 then branch
                        regwrite <= 1'b0;
                        signed_data <= 1;
                    end
                    5'b10000: begin
                        aluop <= 4'b0110;//a<0
                        branch <= 1'b1;//if alu return 0 then branch
                        link <= 1'b1;
                        signed_data <= 1;
                    end
                endcase
            end

            /*↓bgtz↓*/
            6'b000111: begin
                aluop <= 4'b0100;//a>0
                branch <= 1'b1;//if condition satisfied then branch
                regwrite <= 1'b0;
            end

            /*↓blez↓*/
            6'b000110: begin
                aluop <= 4'b0111;//a<=0
                branch <= 1'b1;//if condition satisfied then branch
                regwrite <= 1'b0;
            end

            /*↓bne↓*/
            6'b000101: begin
                aluop <= 4'b1000;//a!=b
                branch <= 1'b1;//if condition satisfied then branch
                regwrite <= 1'b0;
                signed_data <= 1;
            end

            /*↓lw*/
            6'b100011: begin
                aluop <= 4'b0001;
                memread <= 1'b1;
                memtoreg <= 1'b1;
                regdst <= 1'b0;//rt[20:16]
                alusrc <= 1'b1;
                signed_data <= 1;
            end

            /*lb*/
            6'b100000: begin
                aluop <= 4'b0001;
                memread <= 1'b1;
                memtoreg <= 1'b1;
                regdst <= 1'b0;//rt[20:16]
                alusrc <= 1'b1;
                signed_data <= 1;
                byte_access <= 1;
                signed_byte <= 1;
            end

            /*lbu*/
            6'b100100: begin
                aluop <= 4'b0001;
                memread <= 1'b1;
                memtoreg <= 1'b1;
                regdst <= 1'b0;//rt[20:16]
                alusrc <= 1'b1;
                signed_data <= 1;
                byte_access <= 1;
            end

            /*lh*/
            6'b100001: begin
                aluop <= 4'b0001;
                memread <= 1'b1;
                memtoreg <= 1'b1;
                regdst <= 1'b0;//rt[20:16]
                alusrc <= 1'b1;
                signed_data <= 1;
                byte_access <= 1;
                signed_byte <= 1;
            end

            /*lhu*/
            6'b100101: begin
                aluop <= 4'b0001;
                memread <= 1'b1;
                memtoreg <= 1'b1;
                regdst <= 1'b0;//rt[20:16]
                alusrc <= 1'b1;
                signed_data <= 1;
                byte_access <= 1;
            end

            /*sb*/
            6'b101000: begin
                aluop <= 4'b0001;
                memread <= 1'b1;
                memtoreg <= 1'b1;
                regdst <= 1'b0;//rt[20:16]
                alusrc <= 1'b1;
                signed_data <= 1;
                byte_access <= 1;
                signed_byte <= 1;
            end

            /*sh*/
            6'b101001: begin
                aluop <= 4'b0001;
                memread <= 1'b1;
                memtoreg <= 1'b1;
                regdst <= 1'b0;//rt[20:16]
                alusrc <= 1'b1;
                signed_data <= 1;
                byte_access <= 1;
                signed_byte <= 1;
            end

            /*↓sw*/
            6'b101011: begin
                aluop <= 4'b0001;
                memwrite <=1'b1;
                alusrc <= 1'b1;
                regwrite <= 1'b0;
                signed_data <= 1;
            end

            /*j*/
            6'b000010: begin
                jump <= 1'b1;
                regwrite <= 1'b0;
            end

            /*jal*/
            6'b000011: begin
                jump <= 1;
                link <= 1;
            end
            /*ori*/
            6'b001101: begin
                aluop <= 4'b1001;
                regdst <= 1'b0;//rd[20:16]
                alusrc <= 1'b1;//data from instruction
            end
            6'b001010: begin //slti
                aluop <= 4'b1010;
                regdst <= 1'b0;
                alusrc <= 1'b1;
                signed_data <= 1;
            end
            6'b001011: begin
                aluop <= 4'b1011;
                regdst <= 1'b0;
                alusrc <= 1'b1;
            end
        endcase
    end


    
endmodule