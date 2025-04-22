`include "instructionFetch.v"

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
    #10
    $display("outPC:%08h, inst:%08h",outPC, outInst);
end
endmodule