
module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [4:0] sum_temp;
    wire correction;
    wire [4:0] sum_corrected;
    
    assign sum_temp = A + B + Cin;
    assign correction = (sum_temp > 9);
    
    assign sum_corrected = correction ? (sum_temp + 5'd6) : sum_temp;
    
    assign Sum = sum_corrected[3:0];
    assign Cout = sum_corrected[4];
    
endmodule
