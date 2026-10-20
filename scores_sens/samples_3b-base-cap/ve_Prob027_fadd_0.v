
module TopModule (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    
    wire sum1, sum2, sum3;

    
    half_adder ha1 (
        .a(a),
        .b(b),
        .sum(sum1),
        .cout(cout)
    );

    
    half_adder ha2 (
        .a(sum1),
        .b(sum2),
        .sum(sum2),
        .cout(sum3)
    );

    
    assign sum = sum3;

endmodule


module half_adder (
    input a,
    input b,
    output sum,
    output cout
);

    
    assign sum = a ^ b;
    assign cout = a & b;

endmodule
