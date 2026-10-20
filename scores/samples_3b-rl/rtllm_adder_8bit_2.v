
module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

    wire [7:0] carry;
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;

    
    full_adder fa0 (sum0[0], carry[0], a[0], b[0], cin);
    
    full_adder fa1 (sum1[0], carry[1], a[1], b[1], carry[0]);
    
    full_adder fa2 (sum2[0], carry[2], a[2], b[2], carry[1]);
    
    full_adder fa3 (sum3[0], carry[3], a[3], b[3], carry[2]);
    
    full_adder fa4 (sum4[0], carry[4], a[4], b[4], carry[3]);
    
    full_adder fa5 (sum5[0], carry[5], a[5], b[5], carry[4]);
    
    full_adder fa6 (sum6[0], carry[6], a[6], b[6], carry[5]);
    
    full_adder fa7 (sum7[0], carry[7], a[7], b[7], carry[6]);

    assign sum[0] = sum0[0];
    assign sum[1] = sum1[0];
    assign sum[2] = sum2[0];
    assign sum[3] = sum3[0];
    assign sum[4] = sum4[0];
    assign sum[5] = sum5[0];
    assign sum[6] = sum6[0];
    assign sum[7] = sum7[0];
    assign cout   = carry[7];

endmodule


module full_adder (
    output reg sum,
    output reg cout,
    input  wire a,
    input  wire b,
    input  wire cin
);
    always @(*) begin
        sum = a ^ b ^ cin;
        cout = (a & b) | (b & cin) | (a & cin);
    end
endmodule
