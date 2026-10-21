
module TopModule (
    input a,
    input b,
    output out
);

    
    wire xor_result;

    
    xor xor_gate (xor_result, a, b);

    
    not not_gate (out, xor_result);

endmodule
