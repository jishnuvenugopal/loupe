
module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    wire [3:0] diff;
    wire [3:0] borrow;

    
    full_subtractor fs (
        .a(A[3]),
        .b(B[3]),
        .cin(1'b0), 
        .d(diff[3]),
        .cout(borrow[3])
    );

    full_subtractor fs2 (
        .a(A[2]),
        .b(B[2]),
        .cin(borrow[3]),
        .d(diff[2]),
        .cout(borrow[2])
    );

    full_subtractor fs3 (
        .a(A[1]),
        .b(B[1]),
        .cin(borrow[2]),
        .d(diff[1]),
        .cout(borrow[1])
    );

    full_subtractor fs4 (
        .a(A[0]),
        .b(B[0]),
        .cin(borrow[1]),
        .d(diff[0]),
        .cout(borrow[0])
    );

    
    always @(*) begin
        if (borrow[0] == 1'b1) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else if (diff == 4'b0000) begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        } else begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    end

endmodule


module full_subtractor (
    input a,
    input b,
    input cin,
    output reg d,
    output reg cout
);

    assign d = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
