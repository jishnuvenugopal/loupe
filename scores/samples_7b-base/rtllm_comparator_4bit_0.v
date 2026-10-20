
module subtractor_8bit(a, b, borrow, diff);
    input [7:0] a, b;
    output borrow, diff;
    reg borrow, diff;

    assign borrow = (a < b);
    assign diff = a - b;
endmodule

module comparator_4bit(A, B, A_greater, A_equal, A_less);
    input [3:0] A, B;
    output A_greater, A_equal, A_less;
    reg A_greater, A_equal, A_less;
    wire [7:0] diff;
    wire borrow;

    
    subtractor_8bit u_sub(A, B, borrow, diff);

    
    assign A_greater = (diff[7] == 1'b0) && (diff[6:0] != 8'b0);
    assign A_equal = (diff[7:0] == 8'b0);
    assign A_less = borrow;
endmodule
