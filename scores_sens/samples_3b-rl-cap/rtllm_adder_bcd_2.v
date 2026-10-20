
module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [3:0] sum;
    wire [3:0] corrected_sum;

    assign sum = A + B + Cin;

    
    assign corrected_sum = (sum > 4'b1001) ? sum - 4'b0110 : sum;

    assign Sum = corrected_sum;
    assign Cout = (corrected_sum > 4'b1001) ? 1'b1 : 1'b0;

endmodule
