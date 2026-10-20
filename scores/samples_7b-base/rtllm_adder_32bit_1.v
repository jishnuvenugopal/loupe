
module cla_16bit (
    input [15:0] a,
    input [15:0] b,
    input carry_in,
    output reg [15:0] sum,
    output reg carry_out
);


wire [15:0] sum_csa;
wire [15:0] carry_p;
wire [15:0] carry_g;


assign carry_g = a & b;
assign carry_p = a | b;


assign sum_csa = a ^ b;


wire [15:0] sum_l, carry_1, carry_2, carry_3;


assign sum_l = sum_csa[0] ^ carry_p[0];
assign carry_1 = carry_g[0] | (carry_p[0] & carry_csa[1]);


assign sum_l = sum_l | (carry_1 & carry_csa[2]);
assign carry_2 = carry_1 & carry_p[2];


assign sum_l = sum_l | (carry_2 & carry_csa[3]);
assign carry_3 = carry_2 & carry_p[3];


assign sum = sum_l | (carry_3 & carry_csa[4]);
assign carry_out = carry_3 & carry_p[4];

endmodule

module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] S,
    output reg C32
);


wire [15:0] A_lo = A[15:0];
wire [15:0] A_hi = A[31:16];
wire [15:0] B_lo = B[15:0];
wire [15:0] B_hi = B[31:16];


wire [15:0] sum_lo;
wire carry_lo;
wire [15:0] sum_hi;
wire carry_hi;

cla_16bit clah_lo (.a(A_lo), .b(B_lo), .carry_in(1'b0), .sum(sum_lo), .carry_out(carry_lo));
cla_16bit clah_hi (.a(A_hi), .b(B_hi), .carry_in(carry_lo), .sum(sum_hi), .carry_out(carry_hi));


assign S[31:16] = sum_hi;
assign S[15:0] = sum_lo;
assign C32 = carry_hi;

endmodule
