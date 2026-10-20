
module TopModule (
    input a,
    input b,
    output out
);

    wire xor_result;

    assign xor_result = a ^ b;
    assign out = ~xor_result;

endmodule
