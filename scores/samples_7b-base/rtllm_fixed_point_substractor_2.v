
module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

    wire sign_a = a[N];
    wire sign_b = b[N];
    wire [N-2:0] int_a = a[N-2:0];
    wire [N-2:0] int_b = b[N-2:0];
    wire [Q-1:0] frac_a = a[Q-1:0];
    wire [Q-1:0] frac_b = b[Q-1:0];
    wire [N-1:0] res;
    wire sign_res;

    
    assign res = sign_a == sign_b ? int_a - int_b : (frac_a > frac_b ? a : b);
    assign sign_res = sign_a == sign_b ? sign_a : (int_a > int_b ? sign_a : ~sign_b);

    
    assign c[N] = (res == 0) ? 0 : sign_res;
    assign c[N-1:0] = res;

endmodule
