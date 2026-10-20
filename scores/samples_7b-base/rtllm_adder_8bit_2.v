
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output reg [7:0] sum,
    output reg cout
);

wire [7:0] carry;


adder_1bit full_adder_0 (
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .cout(carry[0])
);


adder_1bit full_adder_1 (
    .a(a[1]),
    .b(b[1]),
    .cin(carry[0]),
    .sum(sum[1]),
    .cout(carry[1])
);
adder_1bit full_adder_2 (
    .a(a[2]),
    .b(b[2]),
    .cin(carry[1]),
    .sum(sum[2]),
    .cout(carry[2])
);
adder_1bit full_adder_3 (
    .a(a[3]),
    .b(b[3]),
    .cin(carry[2]),
    .sum(sum[3]),
    .cout(carry[3])
);
adder_1bit full_adder_4 (
    .a(a[4]),
    .b(b[4]),
    .cin(carry[3]),
    .sum(sum[4]),
    .cout(carry[4])
);
adder_1bit full_adder_5 (
    .a(a[5]),
    .b(b[5]),
    .cin(carry[4]),
    .sum(sum[5]),
    .cout(carry[5])
);
adder_1bit full_adder_6 (
    .a(a[6]),
    .b(b[6]),
    .cin(carry[5]),
    .sum(sum[6]),
    .cout(carry[6])
);
adder_1bit full_adder_7 (
    .a(a[7]),
    .b(b[7]),
    .cin(carry[6]),
    .sum(sum[7]),
    .cout(carry[7])
);


assign cout = carry[7];

endmodule


module adder_1bit (
    input a,
    input b,
    input cin,
    output reg sum,
    output reg cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
