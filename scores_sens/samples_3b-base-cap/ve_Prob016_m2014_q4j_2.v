
module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    
    module FullAdder (
        input  a,
        input  b,
        input  cin,
        output sum,
        output cout
    );

        assign sum = a ^ b ^ cin;
        assign cout = (a & b) | (b & cin) | (a & cin);

    endmodule

    
    FullAdder FA0 (.a(x[0]), .b(y[0]), .cin(0), .sum(sum[0]), .cout(sum[1]));
    FullAdder FA1 (.a(x[1]), .b(y[1]), .cin(sum[1]), .sum(sum[2]), .cout(sum[3]));
    FullAdder FA2 (.a(x[2]), .b(y[2]), .cin(sum[3]), .sum(sum[4]), .cout(sum[4]));
    FullAdder FA3 (.a(x[3]), .b(y[3]), .cin(sum[4]), .sum(sum[5]), .cout(sum[5]));

endmodule
