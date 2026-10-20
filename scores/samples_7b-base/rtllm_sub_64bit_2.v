
module sub_64bit (
    input wire [63:0] A,
    input wire [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    assign result = A - B;

    
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result = result[63];

    
    assign overflow = (sign_A & !sign_B & sign_result) | (!sign_A & sign_B & !sign_result);

endmodule
