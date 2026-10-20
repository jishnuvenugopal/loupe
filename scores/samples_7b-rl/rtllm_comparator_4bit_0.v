
module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] sub_result;
    wire borrow;

    assign sub_result = A - B;
    assign borrow = (A < B);

    assign A_greater = ~borrow & (sub_result != 4'b0);
    assign A_equal = ~borrow & (sub_result == 4'b0);
    assign A_less = borrow;

endmodule
