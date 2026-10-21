
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    reg [3:0] difference;
    assign difference = A - B;

    
    reg borrow;
    assign borrow = difference[3] & (A[3] & B[3]);

    
    reg [3:0] result;
    assign result = difference & ~borrow;

    
    assign A_greater = result[3];
    assign A_equal = result[2];
    assign A_less = result[1];

endmodule
