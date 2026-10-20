
module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    wire [N-1:0] abs_a, abs_b;
    wire [N-1:0] res;
    wire sign_a, sign_b, sign_res;
    wire [N:0] temp;

    
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];
    assign abs_a = sign_a ? (~a + 1) : a;
    assign abs_b = sign_b ? (~b + 1) : b;

    
    assign temp = abs_a + abs_b;

    
    assign res = sign_a == sign_b ? temp : temp - 1;

    
    assign sign_res = (sign_a == sign_b) || (res > abs_a);

    
    assign c = {sign_res, res[N-1:0]};

endmodule
