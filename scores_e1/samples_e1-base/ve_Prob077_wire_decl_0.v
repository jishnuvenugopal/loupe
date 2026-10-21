
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output reg out_n
);

    
    wire and1_out, and2_out, or_out;

    
    and2 and1 (
        .a(a),
        .b(b),
        .out(and1_out)
    );

    and2 and2 (
        .a(c),
        .b(d),
        .out(and2_out)
    );

    
    or2 or1 (
        .a(and1_out),
        .b(and2_out),
        .out(or_out)
    );

    
    not not1 (
        .in(or_out),
        .out(out_n)
    );

endmodule
