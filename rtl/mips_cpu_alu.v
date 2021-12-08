module mips_cpu_alu (
    input logic[31:0] data_1,
    input logic[31:0] data_2,
    input logic[5:0] fn,
    input logic[4:0] sa,
    input logic[3:0] aluop,
    output logic[31:0] r,
    output logic[31:0] r_lo,
    output logic hi_en, lo_en,
    output logic mfhi, mflo,
    output logic branch_con,
    output logic jump_reg,
    output logic link_reg
);
    logic[63:0] mult_r_u,mult_r;
    logic[31:0] remainder_u,div_r_u;
    logic[31:0] remainder,div_r;
    always @(*) begin
        r <= 32'hxxxxxxxx;
        r_lo <= 32'hxxxxxxxx;
        mult_r_u <= data_1 * data_2;
        mult_r <= $signed(data_1) * $signed(data_2);
        remainder_u <= data_1 % data_2;
        div_r_u <= data_1 / data_2;
        remainder <= $signed(data_1) % $signed(data_2);
        div_r <= $signed(data_1) / $signed(data_2);
        hi_en <= 0;
        lo_en <= 0;
        mfhi <= 0;
        mflo <= 0;
        branch_con <= 1'b0;
        jump_reg <= 1'b0;
        link_reg <= 1'b0;
        case (aluop)
            4'b0000: begin
                case (fn)
                    6'b100001: begin // addu
                        r <= data_1 + data_2;
                    end 
                    6'b100100: begin //and
                        r <= data_1 & data_2;
                    end
                    6'b001000: begin
                        jump_reg <= 1'b1; //jr
                        r <= data_1 + data_2;
                    end
                    6'b001001:begin //jalr;
                        jump_reg <= 1'b1;
                        r <= data_1 + data_2;
                        link_reg <= 1;
                    end
                    6'b010001: begin //move to hi
                        r <= data_1;
                        hi_en <= 1;
                    end
                    6'b010011: begin //move to lo
                        r_lo <= data_1;
                        lo_en <= 1;
                    end
                    6'b010000: begin //mfhi
                        mfhi <= 1;
                    end
                    6'b010010: begin //mflo
                        mflo <= 1;
                    end
                    6'b011000: begin //mult
                        r <= mult_r[63:32];
                        r_lo <= mult_r[31:0];
                        hi_en <= 1;
                        lo_en <= 1;
                    end
                    6'b011001: begin //multu
                        r <= mult_r_u[63:32];
                        r_lo <= mult_r_u[31:0];
                        hi_en <= 1;
                        lo_en <= 1;
                    end
                    6'b100101: begin //or
                        r <= data_1 | data_2;
                    end
                    6'b000000: begin //sll
                        r <= data_2 << sa;
                    end
                    6'b000100: begin //sllv
                        r <= data_2 << data_1;
                    end
                    6'b000010: begin //sra
                        r <= data_2 >>> sa;
                    end
                    6'b000111: begin //srav
                        r <= data_2 >>> data_1;
                    end
                    6'b000010: begin //srl
                        r <= data_2 >> sa;
                    end
                    6'b000110: begin //srlv
                        r <= data_2 >> data_1;
                    end
                    6'b100011: begin //subu
                        r <= data_1 - data_2;
                    end
                    6'b100110: begin //xor
                        r <= data_1 ^ data_2;
                    end
                    6'b011010: begin //div
                        r <= remainder;
                        r_lo <= div_r;
                        hi_en <= 1;
                        lo_en <= 1;
                    end
                    6'b011011: begin //divu
                        r <= remainder_u;
                        r_lo <= div_r_u;
                        hi_en <= 1;
                        lo_en <= 1;
                    end
                    6'b101010: begin //slt
                        r <= ($signed(data_1) < $signed(data_2)) ? 1 : 0;
                    end
                    6'b101011: begin //sltu
                        r <= data_1 < data_2 ? 1 : 0;
                    end
                endcase
            end
            4'b0001: begin//addiu
                r <= data_1 + data_2;
            end
            4'b0010: begin//andi
                r <= data_1 & data_2;
            end
            4'b0011: begin //a=b
                if (data_1 == data_2) begin
                    branch_con <= 1;
                end
            end
            4'b0100: begin //a>0
                if ($signed(data_1) > 0) begin
                    branch_con <= 1;
                end
            end
            4'b0101: begin //a>=0
                if ($signed(data_1) >= 0) begin
                    branch_con <= 1;
                end
            end
            4'b0110: begin //a<0
                if ($signed(data_1) < 0) begin
                    branch_con <= 1;
                end
            end
            4'b0111: begin //a<=0
                if ($signed(data_1) <= 0) begin
                    branch_con <= 1;
                end
            end
            4'b1000: begin
                if (data_1 != data_2) begin//bne
                    branch_con <= 1;
                end
            end
            4'b1001: begin //or
                r <= data_1 | data_2;
            end
            4'b1010: begin //slti
                r <= ($signed(data_1) < $signed(data_2)) ? 1 : 0;
            end
            4'b1011: begin //sltiu
                r <= data_1 < data_2 ? 1 : 0;
            end
        endcase
    end
endmodule