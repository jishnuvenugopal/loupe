
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire and1_out, and2_out, or_out;

    
    and and1 (
        .a(a),
        .b(b),
        .out(and1_out)
    );

    
    and and2 (
        .a(c),
        .b(d),
        .out(and2_out)
    );

    
    or or_out (
        .a(and1_out),
        .b(and2_out),
        .out(or_out)
    );

    
    assign out = or_out;

    
    assign out_n = ~or_out;

endmodule
