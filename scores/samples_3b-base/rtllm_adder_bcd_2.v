
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    
    wire [3:0] Sum_temp;
    wire [3:0] Sum_corrected;
    wire [3:0] Sum_final;

    
    Sum_temp <= A + B + Cin;

    
    
    Sum_corrected <= Sum_temp - 6;

    
    
    Cout <= Sum_temp[3];

    
    
    
    Sum_final <= (Sum_corrected < 10) ? Sum_corrected : Sum_temp;

    
    assign Sum = Sum_final;

endmodule
