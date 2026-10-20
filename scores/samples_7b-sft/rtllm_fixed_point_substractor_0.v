
module fixed_point_subtractor #(
    parameter Q = 8,
    parameter N = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;
    reg sign_a, sign_b;
    reg [N-1:0] a_abs, b_abs;
    reg [N-1:0] sum_abs;

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        if (sign_a == sign_b) begin
            
            if (sign_a == 0) begin
                res = a - b;
            end else begin
                res = b - a;
            end
            res[N-1] = sign_a;
        end else begin
            
            a_abs = sign_a ? (~a + 1) : a;
            b_abs = sign_b ? (~b + 1) : b;
            sum_abs = a_abs + b_abs;

            if (a_abs > b_abs) begin
                res = sum_abs;
                res[N-1] = 0;
            end else begin
                res = sum_abs;
                res[N-1] = 1;
            end
        end

        
        if (res == 0) begin
            res[N-1] = 0;
        end

        c = res;
    end

endmodule
