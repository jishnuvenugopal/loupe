
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    
    wire [3:0] Sum_temp;
    wire [3:0] Sum_corrected;

    
    assign Sum_temp = A + B + Cin;

    
    assign Sum_corrected = Sum_temp - 6 * (Sum_temp > 9'b1001);

    
    assign Sum = Sum_corrected;
    assign Cout = Sum_temp > 9'b1001;

endmodule
