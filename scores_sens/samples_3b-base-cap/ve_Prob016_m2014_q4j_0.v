
module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    
    assign sum = a ^ b ^ cin;

    
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    
    FullAdder adder0(.a(x[0]), .b(y[0]), .cin(0), .sum(sum[0]), .cout(cout0));
    FullAdder adder1(.a(x[1]), .b(y[1]), .cin(adder0.cout), .sum(sum[1]), .cout(cout1));
    FullAdder adder2(.a(x[2]), .b(y[2]), .cin(adder1.cout), .sum(sum[2]), .cout(cout2));
    FullAdder adder3(.a(x[3]), .b(y[3]), .cin(adder2.cout), .sum(sum[3]), .cout(cout3));

    
    assign sum[4] = cout3;

endmodule
