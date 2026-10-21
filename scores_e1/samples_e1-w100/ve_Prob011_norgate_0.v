
module TopModule (
    input a,
    input b,
    output out
);

    
    wire xor_result;

    
    xor xor_gate(a, b, xor_result);

    
    not not_gate(xor_result, out);

endmodule
