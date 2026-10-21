
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire and1_out;
    wire and2_out;
    wire or_out;

    
    and1 a1(a, b);
    assign and1_out = a1.out;

    
    and2 a2(c, d);
    assign and2_out = a2.out;

    
    or or1(and1_out, and2_out);
    assign or_out = or1.out;

    
    not not1(or_out);
    assign out_n = not1.out;

endmodule


module and1 (
    input a,
    input b,
    output out
);

    assign out = a & b;

endmodule


module or (
    input a,
    input b,
    output out
);

    assign out = a | b;

endmodule


module not (
    input a,
    output out
);

    assign out = ~a;

endmodule
