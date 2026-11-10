
module cla_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output reg [15:0] sum,
    output reg [15:0] carry
);

    
    assign sum = a + b;
    assign carry = a & b;

endmodule

module adder_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] sum,
    output reg [31:0] carry
);

    
    cla_16bit cla1 (
        .a(a[15:0]),
        .b(b[15:0]),
        .sum(sum[15:0]),
        .carry(carry[15:0])
    );

    cla_16bit cla2 (
        .a(a[30:16]),
        .b(b[30:16]),
        .sum(sum[31:16]),
        .carry(carry[31:16])
    );

endmodule
