
module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    reg [3:0] diff;
    reg borrow;

    
    assign diff = A - B;

    
    assign borrow = (A < B);

    
    assign A_greater = (diff != 0) && !borrow;

    
    assign A_equal = (diff == 0);

    
    assign A_less = borrow;

endmodule
