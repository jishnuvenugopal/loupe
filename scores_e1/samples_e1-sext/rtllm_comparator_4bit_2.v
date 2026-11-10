
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    
    reg [3:0] result = A - B;

    
    reg borrow = (result[3] == 1'b1);

    
    A_greater = (result != 0) & ~borrow;

    
    A_equal = (result == 0);

    
    A_less = (result != 0) & borrow;
end

endmodule
