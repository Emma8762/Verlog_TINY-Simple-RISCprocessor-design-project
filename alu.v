`include "execute.v"

// the alu will have an adder, multiplier, Divider, Shift Unit, Logical Unit, mov


module alu (
    ldResult,
    clrResult,
    aluSel,
    aluResult,
    isImmediate,
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
    op1,
    op2,
    imm,
    Eq,
    Gt,
    wrFlag,
    clk
);
    input ldResult,clrResult,isImmediate,isAdd,isCmp,isSub,isMul,isDiv,isMod,isLsl,isLsr,isAsr,isOr,isNot,isAnd,isMov,clk;
    input [31:0] op1, op2, imm;
    output [31:0] aluResult;
    wire [31:0] temp_aluResult;
    input [2:0] aluSel;
    output Eq, Gt, wrFlag;
    wire temp_Eq, temp_Gt;
    wire [31:0] BIn;
    wire [31:0] out [0:5];
    mux2to1 m1 (
        .out(BIn),
        .in0(op2),
        .in1(imm),
        .sel(isImmediate)
    );
    // dff dff6(.q(Eq),.d(temp_Eq), .ld(ldResult), .clr(clrResult), .clk(clk) );
    // dff dff5(.q(Gt),.d(temp_Gt), .ld(ldResult), .clr(clrResult), .clk(clk) );
    // dff dff3(.q(aluResult),.d(temp_aluResult),.ld(ldResult),.clr(clrResult),.clk(clk) );

    adder add (
        .result(out[0]),
        .Eq(Eq),
        .Gt(Gt),
        .A(op1),
        .B(BIn),
        .isAdd(isAdd),
        .isSub(isSub),
        .isCmp(isCmp),
        .wrFlag(wrFlag),
        .clk(clk)
    );
    mul mul1 (
        .result(out[1]),
        .A(op1),
        .B(BIn),
        .isMul(isMul)
    );
    div div1 (
        .result(out[2]),
        .A(op1),
        .B(BIn),
        .isDiv(isDiv),
        .isMod(isMod)
    );
    mov mov1 (
        .result(out[3]),
        .B(BIn),
        .isMov(isMov)
    );
    logicUnit logic1 (
        .result(out[4]),
        .A(op1),
        .B(BIn),
        .isOr(isOr),
        .isNot(isNot),
        .isAnd(isAnd)
    );
    shiftUnit shift1 (
        .result(out[5]),
        .A(op1),
        .B(BIn),
        .isLsl(isLsl),
        .isLsr(isLsr),
        .isAsr(isAsr)
    );
    mux6to1 m2 (
        .out(aluResult),
        .in0(out[0]),
        .in1(out[1]),
        .in2(out[2]),
        .in3(out[3]),
        .in4(out[4]),
        .in5(out[5]),
        .sel(aluSel)
    );
endmodule

module mux6to1 (
    output reg [31:0] out,
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [31:0] in4,
    input [31:0] in5,
    input [2:0] sel
);
    always @(*) begin
        case (sel)
            0: out <= in0;
            1: out <= in1;
            2: out <= in2;
            3: out <= in3;
            4: out <= in4;
            5: out <= in5;
            default: ;
        endcase
    end
endmodule

module flags (
    output reg flagE,
    flagGt,
    input Eq,
    Gt,
    wr,
    clk,
    rst
);
    reg [1:0] flagRegister;  // flagRegister[0] is Equal

    always @(posedge clk) begin
        if (rst) begin
            flagRegister[0] = 0;
            flagRegister[1] = 0;
        end else if (wr) begin
            flagRegister[0] = Eq;
            flagRegister[1] = Gt;
        end
        flagE  = flagRegister[0];
        flagGt = flagRegister[1];

    end
endmodule

module adder (
    output [31:0] result,
    output Eq,
    output Gt,
    input [31:0] A,
    input [31:0] B,
    input isAdd,
    isSub,
    isCmp,
    output wrFlag,
    input clk
);
    assign wrFlag = isCmp;
    assign result = isSub ? (A - B) : (isAdd ? A + B : 0);
    assign Eq = isCmp ? (A == B ? 1 : 0) : 0;
    assign Gt = isCmp ? (A > B ? 1 : 0) : 0;
endmodule

module mul (
    output [31:0] result,
    input [31:0] A,
    input [31:0] B,
    input isMul
);
    assign result = isMul ? A * B : 0;
endmodule

module div (
    output [31:0] result,
    input [31:0] A,
    input [31:0] B,
    input isDiv,
    isMod
);
    assign result = isDiv ? A / B : (isMod ? A % B : 0);
endmodule

module mov (
    output [31:0] result,
    input [31:0] B,
    input isMov
);
    assign result = isMov ? B : 0;
    ;
endmodule

module logicUnit (
    output reg [31:0] result,
    input [31:0] A,
    input [31:0] B,
    input isOr,
    isNot,
    isAnd
);
    always @(*) begin
        if (isOr) result = A | B;
        else if (isNot) result = ~B;
        else if (isAnd) result = A & B;
    end
endmodule

module shiftUnit (
    output reg [31:0] result,
    input [31:0] A,
    input [31:0] B,
    input isLsl,
    isLsr,
    isAsr
);
    always @(*) begin
        if (isLsl) result = A << B;
        else if (isLsr) result = A >> B;
        else if (isAsr) result = A >>> B;
    end
endmodule