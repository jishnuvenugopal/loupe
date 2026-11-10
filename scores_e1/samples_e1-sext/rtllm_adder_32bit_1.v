
module adder_32bit (
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] S,
    output reg C32
);


reg [15:0] A16;
reg [15:0] B16;
reg [15:0] S16;
reg [15:0] C16;


assign A16 = A[31:16];
assign B16 = B[31:16];
adder_16bit cla1 (
    .A(A16),
    .B(B16),
    .S(S16),
    .C(C16)
);


assign S[31:16] = S16;
assign S[15:0] = S16;
assign C32 = C16;

endmodule

module adder_16bit (
    input wire [15:0] A,
    input wire [15:0] B,
    output reg [15:0] S,
    output reg C
);


reg [7:0] A7;
reg [7:0] B7;
reg [7:0] S7;
reg [7:0] C7;


assign A7 = A[15:8];
assign B7 = B[15:8];
adder_8bit cla8 (
    .A(A7),
    .B(B7),
    .S(S7),
    .C(C7)
);


assign S[7:0] = S7;
assign C = C7;

endmodule

module adder_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [7:0] S,
    output reg C
);


reg [3:0] A3;
reg [3:0] B3;
reg [3:0] S3;
reg [3:0] C3;


assign A3 = A[7:4];
assign B3 = B[7:4];
adder_4bit cla4 (
    .A(A3),
    .B(B3),
    .S(S3),
    .C(C3)
);


assign S[3:0] = S3;
assign C = C3;

endmodule

module adder_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg [3:0] S,
    output reg C
);


reg [1:0] A1;
reg [1:0] B1;
reg [1:0] S1;
reg [1:0] C1;


assign A1 = A[3:2];
assign B1 = B[3:2];
adder_2bit cla2 (
    .A(A1),
    .B(B1),
    .S(S1),
    .C(C1)
);


assign S[1:0] = S1;
assign C = C1;

endmodule

module adder_2bit (
    input wire [1:0] A,
    input wire [1:0] B,
    output reg [1:0] S,
    output reg C
);


reg [0:0] A0;
reg [0:0] B0;
reg [0:0] S0;
reg [0:0] C0;


assign A0 = A[1:0];
assign B0 = B[1:0];
adder_1bit cla1 (
    .A(A0),
    .B(B0),
    .S(S0),
    .C(C0)
);


assign S[0] = S0;
assign C = C0;

endmodule

module adder_1bit (
    input wire [0:0] A,
    input wire [0:0] B,
    output reg [0:0] S,
    output reg C
);


reg [0:0] A0;
reg [0:0] B0;
reg [0:0] S0;
reg [0:0] C0;


assign A0 = A;
assign B0 = B;
adder_0bit cla0 (
    .A(A0),
    .B(B0),
    .S(S0),
    .C(C0)
);


assign S[0] = S0;
assign C = C0;

endmodule

module adder_0bit (
    input wire [0:0] A,
    input wire [0:0] B,
    output reg [0:0] S,
    output reg C
);


assign S = A;
assign C = B;

endmodule
