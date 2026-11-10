
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    
    reg [3:0] result = A ^ B;
    reg borrow = (A & B) & (result & ~B);

    
    if (borrow) begin
        A_less = 1'b1;
    end else if (result != 0) begin
        A_greater = 1'b1;
    end else begin
        A_equal = 1'b1;
    end
end

endmodule
