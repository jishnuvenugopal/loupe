
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    wire [3:0] diff;

    
    wire borrow;

    
    assign diff = A - B;

    
    assign borrow = (A[3] && B[3]) || (A[2] && B[2] && !diff[3]) || (A[1] && B[1] && !diff[2] && !diff[3]) || (A[0] && B[0] && !diff[1] && !diff[2] && !diff[3]);

    
    assign A_greater = borrow;
    assign A_equal = (diff == 0);
    assign A_less = !borrow && !A_equal;

endmodule
