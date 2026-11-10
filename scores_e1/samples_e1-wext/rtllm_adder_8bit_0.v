
module adder_8bit (
    input wire [7:0] a,  
    input wire [7:0] b,  
    input wire cin,   
    output reg [7:0] sum, 
    output reg cout    
);


module full_adder (
    input wire a,  
    input wire b,  
    input wire cin,   
    output reg sum, 
    output reg cout  
);

    assign sum = a ^ b ^ cin;
  
    assign cout = (a & b) | (b & cin) | (a & cin);
  

endmodule


full_adder fa1 (
    .a(a[7]),
    .b(b[7]),
    .cin(cin),
    .sum(sum[7]),
    .cout(cout[7])
);

full_adder fa2 (
    .a(a[6]),
    .b(b[6]),
    .cin(cout[7]),
    .sum(sum[6]),
    .cout(cout[6])
);

full_adder fa3 (
    .a(a[5]),
    .b(b[5]),
    .cin(cout[6]),
    .sum(sum[5]),
    .cout(cout[5])
);

full_adder fa4 (
    .a(a[4]),
    .b(b[4]),
    .cin(cout[5]),
    .sum(sum[4]),
    .cout(cout[4])
);

full_adder fa5 (
    .a(a[3]),
    .b(b[3]),
    .cin(cout[4]),
    .sum(sum[3]),
    .cout(cout[3])
);

full_adder fa6 (
    .a(a[2]),
    .b(b[2]),
    .cin(cout[3]),
    .sum(sum[2]),
    .cout(cout[2])
);

full_adder fa7 (
    .a(a[1]),
    .b(b[1]),
    .cin(cout[2]),
    .sum(sum[1]),
    .cout(cout[1])
);

full_adder fa8 (
    .a(a[0]),
    .b(b[0]),
    .cin(cout[1]),
    .sum(sum[0]),
    .cout(cout[0])
);

endmodule
