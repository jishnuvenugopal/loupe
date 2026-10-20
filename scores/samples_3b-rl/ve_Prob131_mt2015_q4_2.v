

module A (
    input x,
    input y,
    output reg a_out
);

always @(*) begin
    a_out = (x ^ y) & x;
end

endmodule


module B (
    input x,
    input y,
    output reg b_out
);

always @(*) begin
    b_out = (x & y) ^ (x & ~y);
end

endmodule


module top (
    input x,
    input y,
    output z
);

wire a1_out, a2_out, b1_out, b2_out;
wire or_out, and_out;


A a1 (x, y, a1_out);
A a2 (x, y, a2_out);


B b1 (x, y, b1_out);
B b2 (x, y, b2_out);


assign or_out = a1_out | a2_out;


assign and_out = b1_out & b2_out;


assign z = or_out ^ and_out;

endmodule
