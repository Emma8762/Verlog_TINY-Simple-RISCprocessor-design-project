module memoryUnit(aluResult, op2, isLd,isSt, DataMemResult, readDataMem, readDataMemAddr, writeDataMem, writeDataMemAddr, wrDataMem);
output [31:0]readDataMem, writeDataMem, DataMemResult;
output [31:0]readDataMemAddr, writeDataMemAddr;
output wrDataMem;
input [31:0]aluResult, op2;
input isLd, isSt;
assign wrDataMem = isLd ? 0 : (isSt ? 1 : 0);
assign readDataMemAddr = isLd ? aluResult : 0;
assign writeDataMemAddr = isSt ? aluResult : 0;
assign writeDataMem = isSt ? op2 : 0;
endmodule

module dataMemory(readDataMem, readDataMemAddr, writeDataMem, writeDataMemAddr, wrDataMem, clk);
output reg[31:0] readDataMem;
input [31:0]readDataMemAddr,writeDataMem, writeDataMemAddr;
input wrDataMem, clk;
reg [31:0]dataMemoryChip[0:8196];
always @(posedge clk) begin
    if(!wrDataMem) readDataMem = dataMemoryChip[readDataMemAddr];
        else if(wrDataMem) dataMemoryChip[writeDataMemAddr] = writeDataMem;
        else begin
            readDataMem = 0;
        end
end
endmodule