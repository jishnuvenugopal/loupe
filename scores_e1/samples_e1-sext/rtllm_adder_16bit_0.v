
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire cin,
    output reg [15:0] y,
    output reg [15:0] co
);

wire [7:0] sum[15:0];

for (genvar i = 0;
 i < 16;
 i = i + 1) begin
    adder_8bit adder (
        .a(a[i]),
        .b(b[i]),
        .cin(cin),
        .sum(sum[i]),
        .co(co[i])
    );
end

endmodule
