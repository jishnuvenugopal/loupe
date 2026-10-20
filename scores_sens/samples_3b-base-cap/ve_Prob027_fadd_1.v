
module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    
    assign sum = a ^ b ^ cin;

    
    wire ab = a & b;
    wire ac = a & cin;

    
    assign cout = ab | ac;

endmodule
