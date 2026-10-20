
module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);
    
    wire [63:0] sub_result;
    assign sub_result = A - B;

    
    wire positive_overflow = (~A[63] & B[63] & sub_result[63]);
    wire negative_overflow = (A[63] & ~B[63] & ~sub_result[63]);
    
    
    assign result = sub_result;
    assign overflow = positive_overflow | negative_overflow;

endmodule
