
module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    
    assign result = $signed(A) - $signed(B);

    
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire res_sign = result[63];

    
    assign overflow = (~A_sign & B_sign & res_sign) | (A_sign & ~B_sign & ~res_sign);

endmodule
