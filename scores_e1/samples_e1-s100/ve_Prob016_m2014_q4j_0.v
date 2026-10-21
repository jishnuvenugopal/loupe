
module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    
    module FullAdder (
        input  [1:0] a,
        input  [1:0] b,
        input  [1:0] cin,
        output [1:0] sum,
        output [1:0] cout
    );

        assign sum = a ^ b ^ cin;
        assign cout = (a & b) | (b & cin) | (a & cin);

    endmodule

    
    module FourBitAdder (
        input  [3:0] a,
        input  [3:0] b,
        input  [1:0] cin,
        output [4:0] sum,
        output [1:0] cout
    );

        
        assign sum[3:0] = a[3:0] + b[3:0] + cin;

        
        assign sum[5:4] = (sum[3:0] >> 1) + a[2:1] + b[2:1] + cin;

        
        assign sum[7:6] = (sum[5:4] >> 1) + a[0] + b[0] + cin;

        
        assign cout = sum[7] >> 1;

    endmodule

    
    FourBitAdder fourBitAdder (
        .a(x[3:0]),
        .b(y[3:0]),
        .cin(1'b0),  
        .sum(sum),
        .cout(cout)
    );

endmodule
