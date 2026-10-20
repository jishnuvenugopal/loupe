
module TopModule (
    input a,
    input b,
    output out
);

    
    wire not_a = ~a;
    wire not_b = ~b;

    
    wire and_result = not_a & not_b;

    
    assign out = ~and_result;

endmodule
