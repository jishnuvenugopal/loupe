
module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output reg  sum,
    output reg  cout
);

always @(*) begin
    sum  = a ^ b ^ cin;
    cout = (a & b) | (b & cin) | (a & cin);
end

endmodule

module TopModule (
    input  wire [3:0] x,
    input  wire [3:0] y,
    output reg  [4:0] sum
);

wire c1, c2, c3;

full_adder fa1 (.a(x[0]), .b(y[0]), .cin(1'b0), .sum(sum[0]), .cout(c1));
full_adder fa2 (.a(x[1]), .b(y[1]), .cin(c1),  .sum(sum[1]), .cout(c2));
full_adder fa3 (.a(x[2]), .b(y[2]), .cin(c2),  .sum(sum[2]), .cout(c3));
full_adder fa4 (.a(x[3]), .b(y[3]), .cin(c3),  .sum(sum[3]), .cout(sum[4]));

endmodule
