
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    
    wire and1_output;
    wire and2_output;
    wire or_output;

    
    and and1(a, b, and1_output);
    and and2(c, d, and2_output);

    
    or or_gate(and1_output, and2_output, or_output);

    
    assign out = or_output;

    
    not not_gate(out, out_n);

endmodule
