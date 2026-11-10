
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    reg [3:0] result;
    reg borrow;

    assign result = A - B;
    assign borrow = result[3];

    
    assign A_greater = result[3] && !borrow;
    assign A_equal = result[3] == 0;
    assign A_less = !result[3] && !borrow;

endmodule
