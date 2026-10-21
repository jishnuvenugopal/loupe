
module fixed_point_adder (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    parameter Q = 8;
 
    parameter N = 16;
 

    wire [N-1:0] res;
    wire [N-1:0] carry;

    
    assign res = a + b;

    
    assign res = a - b;

    
    assign c = res;

    
    assign carry = res[N-1];

endmodule
