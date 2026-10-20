
module top_level (
    input wire x,
    input wire y,
    output wire z
);

    
    module_a a1 (x, y, z1);
    module_a a2 (x, y, z2);

    
    module_b b1 (x, y, z3);
    module_b b2 (x, y, z4);

    
    wire or_output;
    or_gate or_gate_instance (z1, z2, or_output);

    
    wire and_output;
    and_gate and_gate_instance (z3, z4, and_output);

    
    xor_gate xor_gate_instance (or_output, and_output, z);

endmodule


module module_a (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule


module module_b (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x & y);
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
