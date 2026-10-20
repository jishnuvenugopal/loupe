
module TopModule (
    input a,
    input b,
    output out
);

    
    wire and_result = a & b;

    
    wire not_result = ~and_result;

    
    assign out = not_result;

endmodule
