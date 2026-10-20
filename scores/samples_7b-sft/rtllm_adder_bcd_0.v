
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [4:0] sum_total = A + B + Cin;

assign Cout = (sum_total >= 10) ? 1'b1 : 1'b0;
assign Sum = (sum_total >= 10) ? (sum_total - 10) : sum_total;

endmodule
