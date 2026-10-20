
module TopModule (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    
    assign sum = a ^ b ^ cin;

    
    assign a_and_b = a & b;
    assign a_and_cin = a & cin;

    
    assign cout = a_and_b | a_and_cin;

endmodule
