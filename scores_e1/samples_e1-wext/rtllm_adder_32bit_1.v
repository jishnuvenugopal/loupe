
module adder_32bit (
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] S,
    output reg C32
);

reg [15:0] carry;
reg [15:0] sum;

always @(A, B) begin
    carry = 0;
    sum = 0;

    for (int i = 0;
 i < 16;
 i++) begin
        sum[i] = A[i] ^ B[i] ^ carry;
        carry = (A[i] & B[i]) | (A[i] & carry) | (B[i] & carry);
    end

    S = sum;
    C32 = carry;
end

endmodule
