
module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output reg [15:0] y,
    output reg Co
);

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output reg [7:0] y,
    output reg Co
);

    reg [7:0] sum_1, carry_1;
    reg [7:0] sum_2, carry_2;

    
    adder_8bit adder_1 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_1),
        .Co(carry_1)
    );

    
    adder_8bit adder_2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_1),
        .y(sum_2),
        .Co(carry_2)
    );

    
    assign y = {sum_2, sum_1};
    assign Co = carry_2;

endmodule
