
module top_level (
    input wire x,
    input wire y,
    output wire z
);

    
    module_a a1 (
        .x(x),
        .y(y),
        .z(a1_z)
    );

    module_a a2 (
        .x(x),
        .y(y),
        .z(a2_z)
    );

    
    module_b b1 (
        .x(x),
        .y(y),
        .z(b1_z)
    );

    module_b b2 (
        .x(x),
        .y(y),
        .z(b2_z)
    );

    
    wire or_output;
    or_gate or_gate_inst (
        .a(a1_z),
        .b(a2_z),
        .out(or_output)
    );

    
    wire and_output;
    and_gate and_gate_inst (
        .a(b1_z),
        .b(b2_z),
        .out(and_output)
    );

    
    xor_gate xor_gate_inst (
        .a(or_output),
        .b(and_output),
        .out(z)
    );

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
    assign z = x ^ y;
endmodule


module or_gate (
    input wire a,
    input wire b,
    output wire out
);
    assign out = a | b;
endmodule


module and_gate (
    input wire a,
    input wire b,
    output wire out
);
    assign out = a & b;
endmodule


module xor_gate (
    input wire a,
    input wire b,
    output wire out
);
    assign out = a ^ b;
endmodule
