
module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] S,
    output reg C32
);

    
    adder_16bit cla1 (
        .A(A[31:16]),
        .B(B[31:16]),
        .S(S[31:16]),
        .Cout(C32)
    );

    adder_16bit cla2 (
        .A(A[15:0]),
        .B(B[15:0]),
        .S(S[15:0]),
        .Cout(Cout)
    );

    
    assign C32 = C32 | Cout;

endmodule

module adder_16bit (
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] S,
    output reg Cout
);

    
    adder_8bit cla1 (
        .A(A[15:8]),
        .B(B[15:8]),
        .S(S[15:8]),
        .Cout(Cout)
    );

    adder_8bit cla2 (
        .A(A[7:0]),
        .B(B[7:0]),
        .S(S[7:0]),
        .Cout(Cout)
    );

    
    assign Cout = Cout | Cout;

endmodule

module adder_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] S,
    output reg Cout
);

    
    adder_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .S(S[7:4]),
        .Cout(Cout)
    );

    adder_4bit cla2 (
        .A(A[3:0]),
        .B(B[3:0]),
        .S(S[3:0]),
        .Cout(Cout)
    );

    
    assign Cout = Cout | Cout;

endmodule

module adder_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S,
    output reg Cout
);

    
    adder_2bit cla1 (
        .A(A[3:2]),
        .B(B[3:2]),
        .S(S[3:2]),
        .Cout(Cout)
    );

    adder_2bit cla2 (
        .A(A[1:0]),
        .B(B[1:0]),
        .S(S[1:0]),
        .Cout(Cout)
    );

    
    assign Cout = Cout | Cout;

endmodule

module adder_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg [1:0] S,
    output reg Cout
);

    
    adder_1bit cla1 (
        .A(A[1:0]),
        .B(B[1:0]),
        .S(S[1:0]),
        .Cout(Cout)
    );

endmodule
