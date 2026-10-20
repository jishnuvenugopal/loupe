
module TopModule (
    input a,
    input b,
    output out
);

    
    wire not_a = ~a;
    wire not_b = ~b;
    wire or_ab = not_a | not_b;
    assign out = or_ab;

endmodule
