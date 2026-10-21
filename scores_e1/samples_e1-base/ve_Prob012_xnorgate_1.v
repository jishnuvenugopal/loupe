
module TopModule (
    input  a,
    input  b,
    output out
);

    
    xor a, b, xor_result;

    
    not xor_result, not_out;

    
    assign out = not_out;

endmodule
