`include "instructionFetch.v"

module decodeInstruction (
    isBranchTaken,
    clrBrnchTrgt,
    ldInst,
    ldDecodeInst,
    clrInst,
    clrDecodeInst,
    opcode,
    iOrReg,
    imm,
    modifier,
    rs1,
    rs2,
    rd,
    readInst,
    presentPC,
    branchTarget,
    clk
);
    wire [31:0] currentInst, tempInst;
    input ldInst, ldDecodeInst, clrDecodeInst, clrInst, isBranchTaken, clrBrnchTrgt, clk;
    input [31:0] readInst, presentPC;
    output [4:0] opcode;
    output iOrReg;
    output [15:0] imm;
    output [1:0] modifier;
    output reg [31:0] branchTarget;
    output [3:0] rs1, rs2, rd;

    assign opcode = currentInst[31:27];
    assign iOrReg = currentInst[26];
    assign rd = currentInst[25:22];
    assign rs1 = currentInst[21:18];
    assign rs2 = currentInst[17:14];
    assign modifier = currentInst[17:16];
    assign imm = currentInst[15:0];
    // dff dff3(.q(currentInst),.d(tempInst),.ld(ldDecodeInst),.clr(clrDecodeInst),.clk(clk) );
    PIPO1 pipo3 (
        .out(currentInst),
        .in (readInst),
        .ld (ldInst),
        .clr(clrInst),
        .clk(clk)
    );
    wire [31:0] signedOffset;
    assign signedOffset = {
        {5{currentInst[26]}}, currentInst[26:0]
    };  // Sign-extend 27-bit to 32-bit

    always @(isBranchTaken) begin
        if (clrBrnchTrgt) branchTarget <= 0;
        else if (isBranchTaken) branchTarget <= (signedOffset << 2) + presentPC;
        $display("Signed Offset: %d, Shifted: %d, presentPC: %d, branchTarget: %d", signedOffset,
                 signedOffset << 2, presentPC, branchTarget);

    end

endmodule