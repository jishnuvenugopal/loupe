
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output reg [7:0] sum,
    output reg cout
);

always @(*) begin
    sum[7] = a[7] ^ b[7] ^ cin;
    sum[6:0] = (a[6:0] ^ b[6:0]) ^ cin;
    cout = (a[7] & b[7]) | (a[6:0] & b[6:0]) | (cin & (a[7] | b[7]));
end

endmodule
