
module TopModule (
    input  a,
    input  b,
    output out
);

    
    wire xor_result;

    
    xor a, b, xor_result;

    
    not xor_result, out;

endmodule
