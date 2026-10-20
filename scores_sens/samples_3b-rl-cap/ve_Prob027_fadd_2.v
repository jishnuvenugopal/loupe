
module TopModule (
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule
