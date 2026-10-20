
module TopModule (
    input a,
    input b,
    output out
);

    
    wire not_a;
    wire not_b;
    wire or_ab;

    
    not not_a_gen (not_a, a);
    not not_b_gen (not_b, b);

    
    or or_ab_gen (or_ab, not_a, not_b);

    
    assign out = or_ab;

endmodule
