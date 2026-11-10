
module sub_64bit (
    input wire [63:0] A,
    input wire [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    assign result = A - B;

    
    assign overflow = ((A[63] == 1'b1) && (B[63] == 1'b0) && (result[63] == 1'b0)) ||
                      ((A[63] == 1'b0) && (B[63] == 1'b1) && (result[63] == 1'b1));

endmodule
