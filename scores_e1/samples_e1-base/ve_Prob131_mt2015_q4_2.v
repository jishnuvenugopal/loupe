
module top (
    input wire x,
    input wire y,
    output reg z
);

    
    A a1 (x, y, z);
    A a2 (x, y, z);
    A a3 (x, y, z);
    A a4 (x, y, z);

    
    B b1 (x, y, z);
    B b2 (x, y, z);
    B b3 (x, y, z);
    B b4 (x, y, z);

    
    or_gate or1 (z, a1.z, a2.z, a3.z, a4.z);

    
    and_gate and1 (z, b1.z, b2.z, b3.z, b4.z);

    
    xor_gate xor1 (z, or1.z, and1.z);

endmodule

module A (
    input wire x,
    input wire y,
    output reg z
);

    
    assign z = (x ^ y) & x;

endmodule

module B (
    input wire x,
    input wire y,
    output reg z
);

    
    assign z = (x ^ y) & x;

endmodule

module or_gate (
    output reg z,
    input wire a,
    input wire b,
    input wire c,
    input wire d
);

    
    assign z = a | b | c | d;

endmodule

module and_gate (
    output reg z,
    input wire a,
    input wire b,
    input wire c,
    input wire d
);

    
    assign z = a & b & c & d;

endmodule

module xor_gate (
    output reg z,
    input wire a,
    input wire b,
    input wire c,
    input wire d
);

    
    assign z = a ^ b ^ c ^ d;

endmodule
