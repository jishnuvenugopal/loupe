
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [8:0] temp;
    assign temp = a + b + cin;
    assign sum = temp[7:0];
    assign cout = temp[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_lower;
    
    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_lower)
    );
    
    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_lower),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule
