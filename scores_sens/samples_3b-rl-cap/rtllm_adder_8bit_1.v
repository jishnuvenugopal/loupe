
module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

    
    wire c1, c2, c3, c4, c5, c6, c7;

    
    wire sum0, c0;
    full_adder fa0 (sum0, c0, a[0], b[0], cin);

    
    wire sum1, c1a;
    full_adder fa1 (sum1, c1a, a[1], b[1], c0);

    
    wire sum2, c2a;
    full_adder fa2 (sum2, c2a, a[2], b[2], c1a);

    
    wire sum3, c3a;
    full_adder fa3 (sum3, c3a, a[3], b[3], c2a);

    
    wire sum4, c4a;
    full_adder fa4 (sum4, c4a, a[4], b[4], c3a);

    
    wire sum5, c5a;
    full_adder fa5 (sum5, c5a, a[5], b[5], c4a);

    
    wire sum6, c6a;
    full_adder fa6 (sum6, c6a, a[6], b[6], c5a);

    
    wire sum7, c7a;
    full_adder fa7 (sum7, c7a, a[7], b[7], c6a);

    
    assign sum[0] = sum0;
    assign sum[1] = sum1;
    assign sum[2] = sum2;
    assign sum[3] = sum3;
    assign sum[4] = sum4;
    assign sum[5] = sum5;
    assign sum[6] = sum6;
    assign sum[7] = sum7;
    assign cout   = c7a;

endmodule


module full_adder (
    output sum,
    output cout,
    input  a,
    input  b,
    input  cin
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
