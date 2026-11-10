
module TopModule (
    input a,
    input b,
    output out
);

    
    assign not_a = ~a;
    assign not_b = ~b;

    
    assign out = not_a | not_b;

endmodule
