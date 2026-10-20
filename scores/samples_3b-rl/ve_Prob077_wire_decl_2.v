
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    
    wire and1_out;
    wire and2_out;

    
    wire or_out;

    
    and and1 (and1_out, a, b);
    and and2 (and2_out, c, d);

    
    or or1 (or_out, and1_out, and2_out);

    
    not not1 (out_n, or_out);

    
    assign out = or_out;

endmodule
