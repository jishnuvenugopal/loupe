
module adder_16bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output reg [7:0] y,
    output reg Co
);

reg [7:0] sum;
reg [7:0] carry;

always @(*) begin
    sum = a + b + Cin;
    carry = sum[8];
    y = sum[7:0];
    Co = carry;
end

endmodule
