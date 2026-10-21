
module TopModule (
    input  a,
    input  b,
    output out
);

    
    xor_gate xor_gate (
        .a(a),
        .b(b),
        .out(xor_out)
    );

    
    not_gate not_gate (
        .in(xor_out),
        .out(out)
    );

endmodule
