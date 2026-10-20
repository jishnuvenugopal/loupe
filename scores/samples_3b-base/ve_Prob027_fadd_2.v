
module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    
    wire half_adder_sum1;
    wire half_adder_carry1;
    half_adder ha1 (
        .a(a),
        .b(b),
        .sum(half_adder_sum1),
        .carry(half_adder_carry1)
    );

    
    wire half_adder_sum2;
    wire half_adder_carry2;
    half_adder ha2 (
        .a(half_adder_sum1),
        .b(cin),
        .sum(half_adder_sum2),
        .carry(half_adder_carry2)
    );

    
    assign sum = half_adder_sum2;
    assign cout = half_adder_carry2;

endmodule


module half_adder (
    input  a,
    input  b,
    output sum,
    output carry
);

    
    assign sum = a ^ b;

    
    assign carry = a & b;

endmodule
