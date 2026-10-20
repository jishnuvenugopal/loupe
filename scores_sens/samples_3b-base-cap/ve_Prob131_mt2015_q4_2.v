
module top_level (
    input wire x,
    input wire y,
    output wire z
);

    
    A a1 (x, y, z1);
    A a2 (x, y, z2);

    
    B b1 (x, y, z3);
    B b2 (x, y, z4);

    
    wire or_output;
    or_gate or_gate_instance (z1, z2, or_output);

    
    wire and_output;
    and_gate and_gate_instance (z3, z4, and_output);

    
    xor_gate xor_gate_instance (or_output, and_output, z);

endmodule


module A (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x ^ y;
endmodule


module B (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x;
endmodule


module or_gate (
    input wire a,
    input wire b,
    output wire z
);
    assign z = a | b;
endmodule


module and_gate (
    input wire a,
    input wire b,
    output wire z
);
    assign z = a & b;
endmodule


module xor_gate (
    input wire a,
    input wire b,
    output wire z
);
    assign z = a ^ b;
endmodule
