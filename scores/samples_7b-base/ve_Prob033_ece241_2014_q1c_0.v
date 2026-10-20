
module TopModule (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);


reg [15:0] sum;
assign sum = $signed(a) + $signed(b);


assign s = sum[7:0];


assign overflow = (a[7] == b[7]) && (a[7] != sum[7]);

endmodule
