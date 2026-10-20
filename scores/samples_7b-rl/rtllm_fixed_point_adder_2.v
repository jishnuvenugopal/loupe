
module fixed_point_adder #(
    parameter Q = 16,
    parameter N = 32
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

    reg [N-1:0] res;
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire a_gt_b = ($signed(a) > $signed(b));

    always @* begin
        if (sign_a == sign_b) begin
            res = a + b;
        end else begin
            if (a_gt_b) begin
                res = a - b;
            end else begin
                res = b - a;
            end
        end
    end

    assign c = res;

endmodule
