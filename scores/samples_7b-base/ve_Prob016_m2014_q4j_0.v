
module TopModule(
    input [3:0] x,
    input [3:0] y,
    output reg [4:0] sum
);

    wire [3:0] carry;

    
    FullAdder fa0(x[0], y[0], 0, sum[0], carry[0]);

    
    FullAdder fa1(x[1], y[1], carry[0], sum[1], carry[1]);

    
    FullAdder fa2(x[2], y[2], carry[1], sum[2], carry[2]);

    
    FullAdder fa3(x[3], y[3], carry[2], sum[3], sum[4]);

endmodule

module FullAdder(
    input a,
    input b,
    input cin,
    output reg s,
    output reg cout
);

    assign {cout, s} = a + b + cin;

endmodule
