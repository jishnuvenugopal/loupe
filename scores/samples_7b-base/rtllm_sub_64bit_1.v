
module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    wire [63:0] A_inv;
  

    
    assign A_inv = (~A) + 1;

    
    assign result = A + A_inv;

    
    assign overflow = (A[63] == 0 && B[63] == 1 && result[63] == 1) ||  
                        (A[63] == 1 && B[63] == 0 && result[63] == 0);
 

endmodule
