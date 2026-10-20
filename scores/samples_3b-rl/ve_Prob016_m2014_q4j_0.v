
module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    wire [3:0] carry;
    wire [3:0] sum0, sum1, sum2, sum3;

    
    full_adder fa0(.a(x[3]), .b(y[3]), .c_in(0), .sum(sum0[3]), .c_out(carry[3]));
    full_adder fa1(.a(x[2]), .b(y[2]), .c_in(carry[3]), .sum(sum0[2]), .c_out(carry[2]));
    full_adder fa2(.a(x[1]), .b(y[1]), .c_in(carry[2]), .sum(sum0[1]), .c_out(carry[1]));
    full_adder fa3(.a(x[0]), .b(y[0]), .c_in(carry[1]), .sum(sum0[0]), .c_out(carry[0]));

    
    full_adder fa4(.a(x[4]), .b(y[4]), .c_in(carry[0]), .sum(sum1), .c_out(carry[4]));
    full_adder fa5(.a(1'b0), .b(1'b0), .c_in(carry[4]), .sum(sum2), .c_out(carry[5]));
    full_adder fa6(.a(1'b0), .b(1'b0), .c_in(carry[5]), .sum(sum3), .c_out(carry[6]));
    full_adder fa7(.a(1'b0), .b(1'b0), .c_in(carry[6]), .sum(sum4), .c_out(carry[7]));

    
    assign sum[4] = sum4;
    assign sum[3] = sum3;
    assign sum[2] = sum2;
    assign sum[1] = sum1;
    assign sum[0] = sum0[0];

endmodule


module full_adder (
    input  a,
    input  b,
    input  c_in,
    output sum,
    output c_out
);
    assign sum = a ^ b ^ c_in;
    assign c_out = (a & b) | (b & c_in) | (a & c_in);
endmodule
