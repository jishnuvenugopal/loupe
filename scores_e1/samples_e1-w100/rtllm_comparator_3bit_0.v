
module comparator_3bit (
    input wire [2:0] A,
    input wire [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    assign A_greater = (A[2] > B[2]);
    assign A_less = (A[2] < B[2]);

    
    assign A_equal = (A[1] == B[1]);

    
    assign A_equal = (A[0] == B[0]);

endmodule
