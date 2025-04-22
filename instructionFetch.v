
// Here we will fetch the instruction from the instruction memery and load it in instruction register
module instructionMem (
    readAddr,
    readData,
    writeAddr,
    writeData,
    wr,
    clk,
    reset
);
    parameter widthMem = 32;
    input [widthMem-1:0] readAddr, writeAddr;
    input [widthMem-1:0] writeData;
    input wr, clk, reset;
    output [widthMem-1:0] readData;
    reg [7:0] mem[0:8192];
    assign readData = {mem[readAddr+3], mem[readAddr+2], mem[readAddr+1], mem[readAddr]};

    integer i;
    always @(posedge clk) begin
        if (reset) for (i = 0; i < 256; i = i + 1) mem[i] <= 0;
        else if (wr)
            {mem[writeAddr+3], mem[writeAddr+2], mem[writeAddr+1], mem[writeAddr]} <= writeData;
    end
endmodule

module fetchUnit (
    ldPC,
    ldNPC,
    clrNPC,
    ldInst,
    clrInst,
    clrPC,
    isBranchTaken,
    readInst,
    outPC,
    outInst,
    branchPC,
    clk
);  // ldPC, clrPC, isBranchTaken, outPC,branchPC
    output [31:0] outPC, outInst;
    input [31:0] branchPC, readInst;
    input ldPC, ldInst, ldNPC, clrNPC, clrInst, clrPC, isBranchTaken, clk;
    wire [31:0] nextPC;  // output of the adder
    wire [31:0] presentPC;
    wire [31:0] tempPC;
    PIPO1 pipo1 (
        .out(outPC),
        .in (presentPC),
        .ld (ldPC),
        .clr(clrPC),
        .clk(clk)
    );
    dff dff1 (
        .q  (nextPC),
        .d  (tempPC),
        .ld (ldNPC),
        .clr(clrNPC),
        .clk(clk)
    );
    mux2to1 mux1 (
        .out(presentPC),
        .in0(nextPC),
        .in1(branchPC),
        .sel(isBranchTaken)
    );
    addFour addFour1 (
        .sum(tempPC),
        .in (outPC)
    );
    PIPO1 pipo2 (
        .out(outInst),
        .in (readInst),
        .ld (ldInst),
        .clr(clrInst),
        .clk(clk)
    );
endmodule

module dff (
    output reg [31:0] q,
    input [31:0] d,
    input ld,
    clr,
    clk
);
    wire clk_internal;
    assign clk_internal = clk & ld;
    always @(posedge clk_internal) begin
        if (clr) q <= 0;
        else if (ld) q <= d;
    end
endmodule



module PIPO1 (
    output reg [31:0] out,
    input [31:0] in,
    input ld,
    clr,
    clk
);
    always @(posedge clk) begin
        if (clr) out <= 0;
        else if (ld) out <= in;
    end
endmodule
module mux2to1 (
    output [31:0] out,
    input [31:0] in0,
    input [31:0] in1,
    input sel
);
    assign out = sel ? in1 : in0;
endmodule
module addFour (
    output [31:0] sum,
    input  [31:0] in
);
    assign sum = in + 4;
endmodule