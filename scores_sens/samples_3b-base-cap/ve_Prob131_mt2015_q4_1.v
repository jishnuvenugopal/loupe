
module top_module (
    input wire x,
    input wire y,
    output wire z
);


module A (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x ^ y);
endmodule


module B (
    input wire x,
    output wire z
);
    assign z = x;
endmodule


A a1 (x, y, z1);
A a2 (x, y, z2);
B b1 (x, z3);
B b2 (x, z4);


assign z = z1 | z2;


assign z = z3 & z4;

endmodule
