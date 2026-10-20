
module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    wire [63:0] A_sign = A[63];
    wire [63:0] B_sign = B[63];

    
    wire [63:0] result_sign = result[63];

    
    wire [64:0] temp_result;

    
    assign temp_result = A - B;

    
    
    
    assign overflow = (A_sign == 1'b1 && B_sign == 1'b0 && result_sign == 1'b1) ||
                      (A_sign == 1'b0 && B_sign == 1'b1 && result_sign == 1'b0);

    
    assign result = temp_result[63:0];

endmodule
