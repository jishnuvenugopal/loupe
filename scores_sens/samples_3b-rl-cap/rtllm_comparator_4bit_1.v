
module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] A_minus_B;

    
    assign A_minus_B = A - B;

    
    assign A_less = (A_minus_B < 5'b00000);

    
    assign A_greater = (A_minus_B >= 5'b00000) && (A_minus_B != 5'b00000);

    
    assign A_equal = (A_minus_B == 5'b00000);

endmodule
