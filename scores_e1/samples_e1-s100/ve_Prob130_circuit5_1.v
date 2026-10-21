
module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

    
    xor_gate x0 (q[0], a[0], b[0]);
    xor_gate x1 (q[1], a[1], b[1]);
    xor_gate x2 (q[2], a[2], b[2]);
    xor_gate x3 (q[3], a[3], b[3]);

endmodule

module xor_gate (
    output reg q,
    input a,
    input b
);

    
    assign q = a ^ b;

endmodule
