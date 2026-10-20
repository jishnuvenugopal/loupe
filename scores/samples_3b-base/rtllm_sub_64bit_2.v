
module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    wire [63:0] sign_A = A[63];
    wire [63:0] sign_B = B[63];

    
    wire [63:0] sign_result;

    
    wire [64:0] temp_result;

    
    assign temp_result = A - B;

    
    assign sign_result = temp_result[64];

    
    assign overflow = (sign_A == sign_B) ? (sign_result != sign_A) : (sign_result == sign_A);

    
    assign result = temp_result[63:0];

endmodule
