
module A (
    input x,
    input y,
    output z
);

assign z = (x ^ y) & x;

endmodule

module B (
    input x,
    input y,
    output z
);

assign z = x & y;

endmodule

module top (
    input x,
    input y,
    output z
);

wire a1_out, b1_out, a2_out, b2_out, or_out, and_out, xor_out;

A a1 (a1_out, y, x);
A a2 (a2_out, y, x);
B b1 (b1_out, y, x);
B b2 (b2_out, y, x);

or or1 (or_out, a1_out, b1_out);
and and1 (and_out, a2_out, b2_out);
xor xor1 (xor_out, or_out, and_out);

assign z = xor_out;

endmodule
