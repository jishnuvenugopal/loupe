
module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    reg [3:0] subtract_result;
    wire borrow;

    assign subtract_result = A - B;
    assign borrow = (A < B);

    
    always @(*) begin
        if (subtract_result == 4'b0000) begin
            A_equal = 1;
            A_greater = 0;
            A_less = 0;
        end else if (subtract_result > 4'b0000) begin
            A_equal = 0;
            A_greater = 1;
            A_less = 0;
        end else begin
            A_equal = 0;
            A_greater = 0;
            A_less = 1;
        end
    end

endmodule
