`include "instructionDecode.v"
module tb;
reg[31:0] readAddr, writeAddr;
wire [31:0]readData;
reg [31:0]writeData;
reg wr,reset;
reg clk = 0;
reg [31:0]mem[0:255];
reg ldPC, ldInst, ldNPC,clrNPC,clrInst, clrPC,isBranchTaken;
reg [31:0]branchPC = 0;
wire  [31:0]outPC, outInst,readInst;
wire [4:0]opcode;
reg ldBrnchTrgt,clrBrnchTrgt,clrDecodeInst,ldDecodeInst;
 decodeInstruction decode(ldDecodeInst,ldDecodeInst,ldBrnchTrgt,clrBrnchTrgt,clrDecodeInst,clrDecodeInst,opcode, iOrReg,imm,modifier,rs1,rs2,rd,outInst,outPC,branchTarget,clk);
fetchUnit fetch(ldPC,ldNPC,clrNPC,ldInst,clrInst,clrPC,isBranchTaken,readInst,outPC,outInst ,branchPC,clk); // ldPC, clrPC, isBranchTaken, outPC,branchPC
instructionMem mem1(outPC, readInst, writeAddr, writeData, wr,clk, reset);
always #5 clk = ~clk;
initial begin
    wr = 0;
    writeAddr = 0;
    writeData = 0;
    readAddr = 0;
    reset = 0;
    #10 reset = 1;
    #10 reset = 0;
    #1500 $finish;
end
integer i;
initial begin
    #30;
    $readmemb("data.bin", mem, 0, 16);
    wr = 1;
    for (i=0;i<17;i=i+1) begin
        writeAddr = i*4;
        writeData = mem[i];
        #10;
        $display("Wrote: Addr[%0d] = %08h",writeAddr,writeData);
    end
    #10;
    wr = 0;
    isBranchTaken = 0;
    clrPC = 1;
    clrInst = 1;
    #10;
    clrNPC = 1;
    clrBrnchTrgt = 1;
    #10;
    clrDecodeInst = 1;
#10;
    for(i=0;i<17;i=i+1) begin
        ldNPC = 0;
        clrInst = 0;
        ldPC = 1;
        clrNPC = 0;
        clrPC = 0;
        #10;
        ldPC = 0;
        ldInst = 1;

        #10;
        ldInst = 0;
        ldNPC = 1;
        #10;
        $display("Read: Addr[%0d] = %08h",outPC,readInst);
        // ldDecodeInst = 0;
       // $display("Opcode:%b, rs1:%b, rs2:%b, rd:%b, imm:%b, iOrReg:%b,modifier:%b",opcode,rs1,rs2,rd,imm,iOrReg,modifier);

    end
    $display("\n\n");
    isBranchTaken = 0;
    ldInst = 0;
    clrInst = 1;
    #10;
    clrInst = 0;
    clrNPC = 1;
    #10;
    ldPC = 0;
    clrPC = 1;
    #10;
    clrNPC = 0;
    ldNPC = 1;
    #10;
    $display("outPC:%08h, inst:%08h",outPC, outInst);
    ldPC = 1;
    clrPC = 0;
    ldNPC = 0;
    #10;
    $display("outPC:%08h, inst:%08h",outPC, outInst);
    ldPC = 0;
    ldInst = 1;
    ldNPC = 0;
    #10;
    $display("outPC:%08h, inst:%08h",outPC, outInst);
    isBranchTaken = 1;
    branchPC = 32'd10;
    #10;
    $display("outPC:%08h, inst:%08h",outPC, outInst);
    ldPC = 1;
    #10
    $display("outPC:%08h, inst:%08h",outPC, outInst);
    ldPC = 0;
    ldInst = 1;
    #10
    $display("outPC:%08h, inst:%08h",outPC, outInst);
    ldInst = 0;
    isBranchTaken = 0;
#10;
    ldPC = 1;
    clrDecodeInst = 0;
    ldDecodeInst = 1;
    #10
    $display("outPC:%08h, inst:%08h",outPC, outInst);
        ldInst = 1;
    #10;
    ldDecodeInst = 1;
    #10;
    $display("Opcode:%b, rs1:%b, rs2:%b, rd:%b, imm:%b, iOrReg:%b, modifier:%b", decode.opcode, decode.rs1, decode.rs2, decode.rd, decode.imm, decode.iOrReg, decode.modifier);


end
endmodule