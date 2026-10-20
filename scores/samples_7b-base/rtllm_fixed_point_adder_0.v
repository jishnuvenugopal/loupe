
module fixed_point_adder #(parameter Q=8, parameter N=16) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res;
reg sign_a, sign_b, sign_c;

assign sign_a = a[N-1];
assign sign_b = b[N-1];


assign res[Q-1:0] = sign_a ? ~a[Q-1:0] + 1 : a[Q-1:0];
assign res[N-1:Q] = sign_b ? ~b[N-1:Q] + 1 : b[N-1:Q];


assign sign_c = sign_a == sign_b;


always @(*) begin
    if (sign_a != sign_b) begin
        if (a[Q-1:0] >= b[Q-1:0]) begin
            res = a - b;
            sign_c = 0;
        end else begin
            res = b - a;
            sign_c = 1;
        end
    end else begin
        
        res = a + b;
    end
end


assign c[N-1] = sign_c;
assign c[N-2:0] = res[N-2:0];

endmodule
