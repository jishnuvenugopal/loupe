
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
    input wire y,
    output wire z
);
    assign z = x;
endmodule


A a1 (x, y, .z(a1_z));
A a2 (x, y, .z(a2_z));


B b1 (x, y, .z(b1_z));
B b2 (x, y, .z(b2_z));


or2 or_gate (a1_z, a2_z, .z(or_gate_out));


and2 and_gate (b1_z, b2_z, .z(and_gate_out));


xor2 xor_gate (or_gate_out, and_gate_out, .z(z));

endmodule
