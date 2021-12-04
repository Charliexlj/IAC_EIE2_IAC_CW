// AND  | 00001
// ADD  | 00010

// BEQ  | 00011
// BGTZ | 00100
// BGEZ | 00101
// BLTZ | 00110
// BLEZ | 00111
// BNE  | 01000

// DIV  | 01001
// DIVU | 01010
// MUL  | 01011
// MULTU| 01100
// OR   | 01101

// SLL  | 01111
// SLT  | 10000
// SLTU | 10001
// SRA  | 10011
// SRL  | 10100

// SUB  | 10101
// XOR  | 10110

module mips_cpu_alu(
  input logic[31:0] A,
	input logic[31:0] B,
  input logic[4:0] alu_ctrl,
  output logic[31:0] reg_hi,
	output logic[31:0] reg_lo, 
  output logic branch_con
);

  logic[31:0] y, i;
	logic[63:0] result;
	logic signed [31:0] signed_a, signed_b;
	assign signed_a = A;
	assign signed_b = B;
	assign reg_lo = result[31:0];
	assign reg_hi = result[63:32];

  always @(*) begin
		// $display("%d", result);
    case (alu_ctrl)
			1: // AND
				result <= A & B;
			2: // ADD
				result <= A + B;
			3: // BEQ
				branch_con <= ( A == B ) ? 1 : 0;
			4: // BGTZ A > 0 
				branch_con <= ( (A[31] != 1) && (A != 0) ) ? 1 : 0;	
			5: // BGEZ A >= 0
				branch_con <= ( A[31] != 1 ) ? 1 : 0;	
			6: // BLTZ A < 0
				branch_con <= ( A[31] == 1 ) ? 1 : 0;	
			7: // BLEZ A <= 0
				branch_con <= ( (A[31] == 1) || (A == 0) ) ? 1 : 0;	
			8: // BNE
				branch_con <= ( A != 0 ) ? 1 : 0;	
			9: // DIV
				result <= signed_a / signed_b;
			10: // DIVU
				result <= A / B;
      11: // MUL
				result = signed_a * signed_b;
      12: // MULTU
				result = A * B;
			13: // OR
				result <= A | B;
			14: // SLL
				result <= A << (B);	
			15: // SLT
				result <= signed_a < signed_b;
			16: // SLTU
				result <= A < B;
			17: //  SRL
				result <= A >> (B);
			18: // SRA
				result <= A >>> (B);
			19: // SUB
				result <= A + (~B + 1);
			20: // XOR
				result <= A ^ B;
		endcase
  end
endmodule