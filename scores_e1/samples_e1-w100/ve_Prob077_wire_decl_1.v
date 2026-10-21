
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire and1_out, and2_out, or_out, not_out;

    
    and1_out = and(a, b);
    and2_out = and(c, d);

    
    or_out = or(and1_out, and2_out);

    
    not_out = not(or_out);

    
    assign out = or_out;
    assign out_n = not_out;

endmodule
