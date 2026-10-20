
module fixed_point_subtractor #(
    parameter Q = 4,
    parameter N = 8
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res;
reg [N-1:0] abs_a, abs_b;
reg [N-1:0] sum;
reg res_sign;

always @(*) begin
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    if (sign_a == sign_b) begin
        
        res = a - b;
    end else begin
        
        abs_a = sign_a ? (-a) : a;
        abs_b = sign_b ? (-b) : b;
        sum = abs_a + abs_b;

        
        res_sign = (abs_a > abs_b) ? ~sign_a : sign_a;
        res = {res_sign, sum[N-1:0]};
    end

    
    if (res == 0)
        res[N-1] = 0;

    c = res;
end

endmodule
