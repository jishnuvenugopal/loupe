
module FullAdder (
    input  a,
    input  b,
    input  cin,
    output reg sum,
    output reg cout
);

    
    sum = a ^ b ^ cin;

    
    cout = a & b & cin;

endmodule

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    
    FullAdder fa0 (.a(x[0]), .b(y[0]), .cin(0), .sum(sum[0]), .cout(cout0));
    FullAdder fa1 (.a(x[1]), .b(y[1]), .cin(sum[0]), .sum(sum[1]), .cout(cout1));
    FullAdder fa2 (.a(x[2]), .b(y[2]), .cin(sum[1]), .sum(sum[2]), .cout(cout2));
    FullAdder fa3 (.a(x[3]), .b(y[3]), .cin(sum[2]), .sum(sum[3]), .cout(cout3));

    
    assign sum[4] = cout3;

endmodule
