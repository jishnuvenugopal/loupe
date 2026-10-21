

module cla_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output reg [15:0] sum,
    output reg carry
);

    
    reg [15:0] carry_in;
    reg [15:0] sum_out;
    reg [15:0] carry_out;

    
    assign carry_in = a[15] ^ b[15] ^ carry;
    assign sum_out = a[15] ^ b[15] ^ carry_in;
    assign carry = a[15] & b[15] | carry_in & a[14] | carry_in & b[14];

    
    assign carry_in = sum_out[15] ^ b[14] ^ carry;
    assign sum_out = sum_out[15] ^ b[14] ^ carry_in;
    assign carry = sum_out[15] & b[13] | carry_in & sum_out[14] | carry_in & b[13];

    

    
    assign sum = sum_out;
    assign carry = carry_out;

endmodule


module adder_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] sum,
    output reg carry
);

    
    cla_16bit cla1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .sum(sum[31:16]),
        .carry(carry)
    );

    cla_16bit cla2 (
        .a(a[15:0]),
        .b(b[15:0]),
        .sum(sum[15:0]),
        .carry(carry)
    );

    
    assign cla2.carry = cla1.carry;

endmodule
