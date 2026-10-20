
module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    reg [63:0] borrow;
    reg [63:0] temp_result;

    
    temp_result = A - B;

    
    for (int i = 63;
 i >= 0;
 i--) begin
        borrow = (A[i] & B[i]) | (temp_result[i] & borrow);
        temp_result[i] = A[i] ^ B[i] ^ borrow;
    end

    
    overflow = (A[63] & ~B[63] & ~temp_result[63]) | (~A[63] & B[63] & temp_result[63]);

    
    result = temp_result;

endmodule
