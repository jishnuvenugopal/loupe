
module sub_64bit (
    input wire [63:0] A,
    input wire [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

always @(*) begin
    
    result = A - B;

    
    if (A[63] == 1 && B[63] == 0 && result[63] == 0) begin
        overflow = 1;
    end else if (A[63] == 0 && B[63] == 1 && result[63] == 1) begin
        overflow = 1;
    end else begin
        overflow = 0;
    end
end

endmodule
