
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [8:0] y
);

    wire [7:0] sum;
    wire Cout;

    full_adder fa0(a[0], b[0], Cin, y[0], Cout);
    full_adder fa1(a[1], b[1], Cout, y[1], Cout);
    full_adder fa2(a[2], b[2], Cout, y[2], Cout);
    full_adder fa3(a[3], b[3], Cout, y[3], Cout);
    full_adder fa4(a[4], b[4], Cout, y[4], Cout);
    full_adder fa5(a[5], b[5], Cout, y[5], Cout);
    full_adder fa6(a[6], b[6], Cout, y[6], Cout);
    full_adder fa7(a[7], b[7], Cout, y[7], Cout);

    assign sum = a + b + Cout;
    assign y[8] = sum[8];

endmodule

module full_adder(
    input a,
    input b,
    input Cin,
    output reg y,
    output reg Cout
);

    assign y = a ^ b ^ Cin;
    assign Cout = (a & b) | (Cin & (a ^ b));

endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output reg [15:0] y,
    output reg Co
);

    wire [15:0] sum;
    wire [15:0] carry;

    adder_8bit adder0(a[7:0], b[7:0], Cin, sum[7:0], carry[0]);
    adder_8bit adder1(a[15:8], b[15:8], carry[0], sum[15:8], carry[1]);

    assign Co = carry[1];
    assign y = sum;

endmodule
