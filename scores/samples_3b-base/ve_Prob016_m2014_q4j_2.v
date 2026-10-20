
module TopModule (
    input  [3:0] x,  
    input  [3:0] y,  
    output [4:0] sum  
);

    
    wire [3:0] carry_in;
    wire [3:0] carry_out;
    wire [3:0] sum_3;
    wire [3:0] sum_2;
    wire [3:0] sum_1;
    wire [3:0] sum_0;

    
    full_adder #(.N(4)) adder0 (
        .a(x[3]),
        .b(y[3]),
        .cin(carry_in[3]),
        .sum(sum_3),
        .cout(carry_out[3])
    );

    
    full_adder #(.N(4)) adder1 (
        .a(x[2]),
        .b(y[2]),
        .cin(carry_in[2]),
        .sum(sum_2),
        .cout(carry_out[2])
    );

    
    full_adder #(.N(4)) adder2 (
        .a(x[1]),
        .b(y[1]),
        .cin(carry_in[1]),
        .sum(sum_1),
        .cout(carry_out[1])
    );

    
    full_adder #(.N(4)) adder3 (
        .a(x[0]),
        .b(y[0]),
        .cin(carry_in[0]),
        .sum(sum_0),
        .cout(carry_out[0])
    );

    
    assign sum[4] = carry_out[0];
  
    assign sum[3] = sum_3;
    assign sum[2] = sum_2;
    assign sum[1] = sum_1;
    assign sum[0] = sum_0;

endmodule


module full_adder (
    input  [3:0] a,
    input  [3:0] b,
    input  cin,
    output [3:0] sum,
    output cout
);

    
    wire [3:0] sum_3;
    wire [3:0] sum_2;
    wire [3:0] sum_1;
    wire [3:0] sum_0;

    
    half_adder #(.N(4)) half_adder0 (
        .a(a[3]),
        .b(b[3]),
        .sum(sum_3[3]),
        .cout(sum_3[2])
    );

    
    half_adder #(.N(4)) half_adder1 (
        .a(a[2]),
        .b(b[2]),
        .sum(sum_2[3]),
        .cout(sum_2[2])
    );

    
    half_adder #(.N(4)) half_adder2 (
        .a(a[1]),
        .b(b[1]),
        .sum(sum_1[3]),
        .cout(sum_1[2])
    );

    
    half_adder #(.N(4)) half_adder3 (
        .a(a[0]),
        .b(b[0]),
        .sum(sum_0[3]),
        .cout(sum_0[2])
    );

    
    assign sum[3] = sum_3[3] ^ sum_2[3] ^ sum_1[3] ^ sum_0[3] ^ cin;
    assign sum[2] = sum_3[2] ^ sum_2[2] ^ sum_1[2] ^ sum_0[2];
    assign sum[1] = sum_3[1] ^ sum_2[1] ^ sum_1[1] ^ sum_0[1];
    assign sum[0] = sum_3[0] ^ sum_2[0] ^ sum_1[0] ^ sum_0[0];

    
    assign cout = sum_3[2];

endmodule


module half_adder (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] sum,
    output cout
);

    
    assign sum[3] = a[3] ^ b[3];
    assign sum[2] = a[2] ^ b[2];
    assign sum[1] = a[1] ^ b[1];
    assign sum[0] = a[0] ^ b[0];
    assign cout = a[3] & b[3];

endmodule
