
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [3:0] temp_sum;
    wire [4:0] corrected_sum;

    assign temp_sum = A + B + Cin;

    
    assign corrected_sum = {1'b0, temp_sum} - 4'b0110;

    
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule
