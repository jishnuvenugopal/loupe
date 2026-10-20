
module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [3:0] temp_sum;
    assign temp_sum = A + B + Cin;

    assign Sum = (temp_sum > 9) ? (temp_sum - 6) : temp_sum;
    assign Cout = (temp_sum > 9);

endmodule
