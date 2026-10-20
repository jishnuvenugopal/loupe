
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [4:0] sum_total;
assign sum_total = A + B + Cin;

wire sum_ge10 = (sum_total >= 10);
wire [3:0] corrected_sum = sum_ge10 ? (sum_total[3:0] + 4'd6) : sum_total[3:0];

assign Sum = corrected_sum;
assign Cout = sum_ge10;

endmodule
