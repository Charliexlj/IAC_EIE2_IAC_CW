
// Op   | 'ALUControl' value
// ==========================

// AND  | 0000
// OR   | 0001
// ADD  | 0010
// MUL  | 0011
// MULTU
// XOR  | 0100
// DIV  | 0101
// DIVU
// SUB  | 0110
// SLT  | 0111
// SLTU | 1000
// SLL  | 1001
// SRL  | 1010
// SRA  | 1011


module mips_cpu_alu(
  input logic[31:0] A,
	input logic[31:0] B,
  input logic[3:0] alu_ctrl,
  output logic[31:0] alu_result,
  output logic zero
);

  logic[31:0] y, i;

	always @(alu_result) begin
		if (alu_result == 0 && alu_ctrl != 2) begin
			zero <= 1;
		end else begin
			zero <= 0;
		end
	
	end

  always @(alu_ctrl,A,B) begin
    case (alu_ctrl)
			0: // AND
				alu_result <= A & B;
			1: // OR
				alu_result <= A | B;
			2: // ADD
				alu_result <= A + B;
      3: // MUL
				alu_result <= A * B;
      4: // XOR
				alu_result <= A ^ B;
      5: // DIV
				alu_result <= A % B;
			6: // SUB
				alu_result <= A + (~B + 1);
			7: begin // SLT
				if (A[31] != B[31]) begin
					if (A[31] > B[31]) begin
						alu_result <= 1;
					end else begin
						alu_result <= 0;
					end
				end else begin
					if (A < B)
					begin
						alu_result <= 1;
					end
					else
					begin
						alu_result <= 0;
					end
				end
			end
			8: // SLTU
				alu_result <= A < B;
			9: // SLL
				alu_result <= A << (B);
			10: begin //  SRL
				y = A;
				for (i = B[4:0];i > 0; i = i - 1) begin
					if (B[5] == 1)
						y = {y[0],y[31:1]};
					else
						y = {1'b0,y[31:1]};
				end
				alu_result <= y;
			end
			11: begin // SRA
				y = A;
				for (i = B; i > 0; i = i - 1) begin
					y = {y[31],y[31:1]};
				end
				alu_result <= y;
			end
		endcase
  end
endmodule