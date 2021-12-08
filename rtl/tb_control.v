module tb_control (
);
    logic[5:0] opcode;
    logic[4:0] branch_type;
    logic regdst;
    logic branch;
    logic jump;
    logic memread;
    logic memtoreg;
    logic[3:0] aluop;
    logic memwrite;
    logic alusrc;
    logic regwrite;
    logic link;

    initial begin
        opcode = 6'b001001;
        #1
        $display("opcode: %b",opcode);
        $display("regdst = %b",regdst);
        $display("branch = %b",branch);
        $display("jump = %b",jump);
        $display("memread = %b",memread);
        $display("memtoreg = %b",memtoreg);
        $display("aluop = %b",aluop);
        $display("memwrite = %b",memwrite);
        $display("alusrc = %b",alusrc);
        $display("regwrite = %b",regwrite);
        $display("link = %b",link);
        opcode = 6'b000000;
        #1
        $display("opcode: %b",opcode);
        $display("regdst = %b",regdst);
        $display("branch = %b",branch);
        $display("jump = %b",jump);
        $display("memread = %b",memread);
        $display("memtoreg = %b",memtoreg);
        $display("aluop = %b",aluop);
        $display("memwrite = %b",memwrite);
        $display("alusrc = %b",alusrc);
        $display("regwrite = %b",regwrite);
        $display("link = %b",link);
        opcode = 6'b100011;
        #1
        $display("opcode: %b",opcode);
        $display("regdst = %b",regdst);
        $display("branch = %b",branch);
        $display("jump = %b",jump);
        $display("memread = %b",memread);
        $display("memtoreg = %b",memtoreg);
        $display("aluop = %b",aluop);
        $display("memwrite = %b",memwrite);
        $display("alusrc = %b",alusrc);
        $display("regwrite = %b",regwrite);
        $display("link = %b",link);
        opcode = 6'b101011;
        #1
        $display("opcode: %b",opcode);
        $display("regdst = %b",regdst);
        $display("branch = %b",branch);
        $display("jump = %b",jump);
        $display("memread = %b",memread);
        $display("memtoreg = %b",memtoreg);
        $display("aluop = %b",aluop);
        $display("memwrite = %b",memwrite);
        $display("alusrc = %b",alusrc);
        $display("regwrite = %b",regwrite);
        $display("link = %b",link);
    end

    control c(opcode,branch_type,regdst,branch,jump,memread,memtoreg,aluop,memwrite,alusrc,regwrite,link);
endmodule