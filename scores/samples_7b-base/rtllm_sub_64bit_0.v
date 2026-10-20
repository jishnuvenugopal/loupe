
module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

always @(*) begin
    reg [64:0] sum;
    
    
    sum = $signed(A) - $signed(B);
    
    
    result = sum[63:0];
    overflow = (sum[64] != $signed(A)[63]);
end

endmodule
