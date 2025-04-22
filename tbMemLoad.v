module tb;
reg[31:0] readAddr, writeAddr;
wire [31:0]readData;
reg [31:0]writeData;
reg wr,reset;
reg clk = 0;
reg [31:0]mem[0:255];
instructionMem mem1(readAddr, readData, writeAddr, writeData, wr,clk, reset);
always #5 clk = ~clk;
initial begin
    wr = 0;
    writeAddr = 0;
    writeData = 0;
    readAddr = 0;
    reset = 0;
    #10 reset = 1;
    #10 reset = 0;
    #1000 $finish;
end
integer i;
initial begin
    #30;
    $readmemb("data.bin", mem, 0, 16);
    wr = 1;
    for (i=0;i<17;i=i+1) begin
        writeAddr = i;
        writeData = mem[i];
        #10;
        $display("Wrote: Addr[%0d] = %08h",writeAddr,writeData);
    end
    #10;
    wr = 0;
    for(i=0;i<17;i=i+1) begin
        readAddr = i;
        #10;
        $display("Read: Addr[%0d] = %08h",readAddr,readData);
    end


end
endmodule