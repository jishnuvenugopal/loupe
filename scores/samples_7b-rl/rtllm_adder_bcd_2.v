
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] sum;
    assign sum = A + B + Cin;

    wire correction;
    assign correction = (sum >= 10);

    assign Sum = correction ? (sum - 10) : sum[3:0];
    assign Cout = correction;

endmodule
