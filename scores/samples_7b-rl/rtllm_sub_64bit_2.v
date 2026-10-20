
module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

wire sign_A = A[63];
wire sign_B = B[63];
wire sign_result;

assign result = A - B;
assign sign_result = result[63];

assign overflow = (~sign_A & sign_B & sign_result) | 
                  (sign_A & ~sign_B & ~sign_result);

endmodule
