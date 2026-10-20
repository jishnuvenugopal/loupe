
module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [4:0] result;
    assign result = A - B;

    assign A_less = result[4];
    assign A_equal = result == 5'b0;
    assign A_greater = (result[4] == 1'b1) && (result != 5'b0);

endmodule
