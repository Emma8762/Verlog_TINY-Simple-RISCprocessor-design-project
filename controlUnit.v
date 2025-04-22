module controlUnit (
    isRegWriteback,
    isCall,
    ldResult,
    clrResult,
    aluSel,
    isAdd,
    isCmp,
    isSub,
    isMul,
    isDiv,
    isMod,
    isLsl,
    isLsr,
    isAsr,
    isOr,
    isNot,
    isAnd,
    isMov,
    ldBrnchTarget,
    clrBrnchTarger,
    ldPC,
    clrPC,
    ldInst,
    clrInst,
    ldNPC,
    isBranchTaken
    , clrNPC,
    ldDecodeInst,
    clrDecodeInst,
    isSt,
    isLd,
    isRet,
    rstRegFile,
    ldRegOutputData,
    clrOutputRegData,
    wrFlag,
    rstFlag,
    clk,
    start,
    flagE,
    flagGt,
    opcode,
    iOrReg,
    modifier
);
    output reg isRegWriteback,isCall,ldResult,
    clrResult,
    isAdd,
    isCmp,
    isSub,
    isMul,
    isDiv,
    isMod,
    isLsl,
    isLsr,
    isAsr,
    isOr,
    isNot,
    isAnd,
    isMov,ldPC,
clrPC,
ldInst,
clrInst,
ldNPC
,clrNPC,
ldDecodeInst,
clrDecodeInst,
isSt, isLd,rstFlag,
isRet,
rstRegFile,
ldRegOutputData,
clrOutputRegData,isBranchTaken,wrFlag,ldBrnchTarget,clrBrnchTarger;
    output reg [2:0] aluSel;
    input [1:0] modifier;
    input [4:0] opcode;
    input clk, start, flagE, flagGt, iOrReg;
    parameter s0 = 0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,s7=7,s8=8,s9=9,s10=10
    ,s11=11,s12=12,s13=13,s14=14,s15=15,s16=16,s17=17,s18=18;
    reg [4:0] state;

    always @(opcode) begin
        isCall <= 0;
        isAdd <= 0;
        isCmp <= 0;
        isSub <= 0;
        isMul <= 0;
        isDiv <= 0;
        isMod <= 0;
        isLsl <= 0;
        isLsr <= 0;
        isAsr <= 0;
        isOr <= 0;
        isNot <= 0;
        isAnd <= 0;
        isMov <= 0;
        aluSel <= 0;
        isLd <= 0;
        rstRegFile <= 0;
        isSt <= 0;
        if (opcode == 5'b10010 || opcode == 5'b10011 || opcode == 5'b10100) begin
            isBranchTaken <= 1'b1;
            if (opcode == 5'b10011) isCall <= 1;
        end else if ((opcode == 5'b10000) && flagE) isBranchTaken <= 1'b1;
        else if ((opcode == 5'b10001) && flagGt) isBranchTaken <= 1'b1;
        else begin
            if (isBranchTaken) begin
                ldPC <= 0;
                isBranchTaken <= 1'b0;
            end

        end
        if (opcode == 5'b01110) begin
            isLd <= 1;
            isRegWriteback <= 1;
            isAdd <= 1;
        end
        if (opcode == 5'b01111) begin
            isRegWriteback <= 0;
            isSt <= 1;
            isAdd <= 1;
        end
        if (opcode == 5'b10100) isRet <= 1;
        else isRet <= 0;
        if (opcode == 5'd0) begin
            isAdd  <= 1;
            aluSel <= 3'd0;
        end else if (opcode == 5'd1) begin
            isSub  <= 1;
            aluSel <= 3'd0;
        end else if (opcode == 5'd2) begin
            isMul  <= 1;
            aluSel <= 3'd1;
        end else if (opcode == 5'd3) begin
            isDiv  <= 1;
            aluSel <= 3'd2;

        end else if (opcode == 5'd4) begin
            isMod  <= 1;
            aluSel <= 3'd2;
        end else if (opcode == 5'd5) begin
            isCmp  <= 1;
            aluSel <= 3'd0;
        end else if (opcode == 5'd6) begin
            isAnd  <= 1;
            aluSel <= 3'd4;

        end else if (opcode == 5'd7) begin
            isOr   <= 1;
            aluSel <= 3'd4;

        end else if (opcode == 5'd8) begin
            isNot  <= 1;
            aluSel <= 3'd4;

        end else if (opcode == 5'd9) begin
            isMov  <= 1;
            aluSel <= 3'd3;
        end else if (opcode == 5'd10) begin
            isLsl  <= 1;
            aluSel <= 3'd5;
        end else if (opcode == 5'd11) begin
            isLsr  <= 1;
            aluSel <= 3'd5;

        end else if (opcode == 5'd12) begin
            isAsr  <= 1;
            aluSel <= 3'd5;

        end
    end

    always @(posedge clk) begin
        case (state)
            s0: begin
                if (start) state <= s1;
                else state <= s0;
            end
            s1: begin
                isRegWriteback <= 0;
                isRet <= 0;
                isSt <= 0;
                isLd <= 0;
                rstFlag <= 1;
                rstRegFile <= 1;
                clrOutputRegData <= 1;
                clrBrnchTarger <= 1;
                isBranchTaken <= 0;
                ldDecodeInst <= 0;
                ldPC <= 0;
                ldNPC <= 0;
                ldInst <= 0;
                clrDecodeInst <= 1;
                clrPC <= 1;
                clrNPC <= 1;
                clrInst <= 1;
                clrResult <= 1;
                isAdd <= 0;
                isCmp <= 0;
                isSub <= 0;
                isMul <= 0;
                isDiv <= 0;
                isMod <= 0;
                isLsl <= 0;
                isLsr <= 0;
                isAsr <= 0;
                isOr <= 0;
                isNot <= 0;
                isAnd <= 0;
                isMov <= 0;
                state <= s2;
            end
            s2: begin
                rstRegFile <= 0;
                isCall <= 0;
                clrBrnchTarger <= 0;
                isRegWriteback <= 1;
                ldNPC <= 1;
                ldInst <= 1;
                rstFlag <= 0;
                ldBrnchTarget <= 1;
                clrOutputRegData <= 0;
                clrDecodeInst <= 0;
                clrPC <= 0;
                clrNPC <= 0;
                clrInst <= 0;
                clrResult <= 0;
                ldResult <= 1;
                ldDecodeInst <= 1;
                state <= s3;
            end
            s3: begin
                ldPC <= 0;
                isRegWriteback <= 1;
                state <= s4;
            end
            s4: begin
                ldPC <= 1;
                ldRegOutputData <= 1;
                state <= s5;
            end
            s5: begin
                ldPC  <= 0;
                state <= s6;
            end
            s6: begin
                ldPC  <= 1;
                state <= s7;
            end
            s7: begin
                ldPC  <= 0;
                state <= s8;
            end
            s8: begin
                ldPC  <= 1;
                state <= s9;
            end
            s9: begin
                ldPC  <= 0;

                state <= s6;
            end
            s10: begin
                ldPC  <= 1;

                state <= s11;
            end
            s11: begin
                ldPC  <= 0;


                state <= s12;
            end
            s12: begin
                ldPC  <= 0;

                state <= s13;
            end
            s13: begin

                state <= s14;
            end
            s14: begin
                ldPC  <= 1;

                state <= s15;
            end
            s15: begin
                ldPC  <= 0;

                state <= s16;
            end
            s16: begin

                state <= s17;
            end
            s17: begin
                ldPC  <= 1;

                state <= s18;
            end
            s18: begin
                ldPC  <= 0;
                state <= s3;
            end

            default: begin
                state <= s0;
            end
        endcase
    end

endmodule