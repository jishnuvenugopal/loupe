
module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output reg  [63:0] result,
    output reg        overflow
);

    
    wire [63:0] A_sign, B_sign, result_sign;

    
    assign A_sign  = {64'b0, A[63]};
 
    assign B_sign  = {64'b0, B[63]};
 
    assign result_sign = {64'b0, result[63]};
 

    
    assign result = A - B;

    
    
    
    
    assign overflow = ((~A_sign) & B_sign & result_sign) | 
                     (A_sign & (~B_sign) & (~result_sign));
 

endmodule
