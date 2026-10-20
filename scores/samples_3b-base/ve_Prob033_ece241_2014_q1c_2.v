
module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    
    wire [7:0] sum;
    wire [7:0] carry;

    
    genvar i;
    generate
        for (i = 0;
 i < 8;
 i = i + 1) begin
            full_adder u_adder (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i + 1])
            );
        end
    endgenerate

    
    assign s = sum;

    
    assign overflow = (carry[7] && !carry[8]) || (!carry[7] && carry[8]);

endmodule


module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
