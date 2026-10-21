
module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output reg [4:0] sum,
    output reg overflow
);

    
    module FullAdder (
        input  [1:0] a,
        input  [1:0] b,
        input  [1:0] cin,
        output reg [1:0] sum,
        output reg [1:0] cout
    );

        assign sum = a ^ b ^ cin;
        assign cout = a & b | b & cin | a & cin;

    endmodule

    
    FullAdder FA0 (
        .a(x[3]),
        .b(y[3]),
        .cin(0),
        .sum(sum[4]),
        .cout(cout[4])
    );

    FullAdder FA1 (
        .a(x[2]),
        .b(y[2]),
        .cin(cout[4]),
        .sum(sum[3]),
        .cout(cout[3])
    );

    FullAdder FA2 (
        .a(x[1]),
        .b(y[1]),
        .cin(cout[3]),
        .sum(sum[2]),
        .cout(cout[2])
    );

    FullAdder FA3 (
        .a(x[0]),
        .b(y[0]),
        .cin(cout[2]),
        .sum(sum[1]),
        .cout(cout[1])
    );

    
    assign overflow = (sum[4] & cout[4]) | (sum[3] & cout[3]) | (sum[2] & cout[2]) | (sum[1] & cout[1]);

endmodule
