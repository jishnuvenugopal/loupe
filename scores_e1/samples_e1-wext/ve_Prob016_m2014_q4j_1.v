
module TopModule (
    input wire [3:0] x,
    input wire [3:0] y,
    output reg [4:0] sum,
    output reg overflow
);

    
    full_adder fa (
        .a(x[3]),
        .b(y[3]),
        .cin(1'b0),
        .sum(sum[3]),
        .carry(carry[3])
    );

    
    full_adder fa2 (
        .a(x[2]),
        .b(y[2]),
        .cin(carry[3]),
        .sum(sum[2]),
        .carry(carry[2])
    );

    
    full_adder fa3 (
        .a(x[1]),
        .b(y[1]),
        .cin(carry[2]),
        .sum(sum[1]),
        .carry(carry[1])
    );

    
    full_adder fa4 (
        .a(x[0]),
        .b(y[0]),
        .cin(carry[1]),
        .sum(sum[0]),
        .carry(carry[0])
    );

    
    assign overflow = carry[0];

endmodule

module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output reg sum,
    output reg carry
);

    
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (a & cin);

endmodule
