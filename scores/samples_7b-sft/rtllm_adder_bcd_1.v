
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [4:0] sum_bin = A + B + Cin;
wire [4:0] sum_corrected = (sum_bin >= 10) ? (sum_bin + 6) : sum_bin;

assign Sum = sum_corrected[3:0];
assign Cout = sum_corrected[4];

endmodule
