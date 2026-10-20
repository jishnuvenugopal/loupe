
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    
    wire and1;
    wire and2;
    wire or_result;

    
    and and_gate1(a, b, and1);
    and and_gate2(c, d, and2);

    
    or or_gate(and1, and2, or_result);

    
    assign out = or_result;

    
    assign out_n = ~out;

endmodule
