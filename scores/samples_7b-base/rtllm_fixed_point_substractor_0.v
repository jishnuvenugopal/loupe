
module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

    reg [N-1:0] res;
    reg [N-1:0] a_abs, b_abs;
    reg sign_a, sign_b, sign_res;

    
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];

    
    assign a_abs = sign_a ? ~a + 1 : a;
    assign b_abs = sign_b ? ~b + 1 : b;

    
    always @(*) begin
        if (sign_a == sign_b) begin
            
            if (a_abs >= b_abs) begin
                res = a_abs - b_abs;
                sign_res = sign_a;
            end else begin
                res = b_abs - a_abs;
                sign_res = sign_b;
            end
        end else begin
            
            if (a_abs >= b_abs) begin
                res = a_abs + b_abs;
                sign_res = a_abs[Q-1];
            end else begin
                res = b_abs + a_abs;
                sign_res = b_abs[Q-1];
            end
        end

        
        res[N-1] = sign_res;

        
        if (res == 0) begin
            res[N-1] = 0;
        end
    end

    
    assign c = res;

endmodule
