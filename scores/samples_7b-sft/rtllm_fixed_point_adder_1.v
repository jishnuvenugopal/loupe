
module fixed_point_adder #(
    parameter Q = 4,
    parameter N = 8
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    reg [N-1:0] res;

    always @(*) begin
        reg sign_a, sign_b;
        reg [N-2:0] mag_a, mag_b;
        reg [N-1:0] sum_mag;
        reg [N-2:0] mag_diff;
        reg sign_diff;

        sign_a = a[N-1];
        mag_a = a[N-2:0];
        sign_b = b[N-1];
        mag_b = b[N-2:0];

        if (sign_a == sign_b) begin
            sum_mag = mag_a + mag_b;
            if (sum_mag >= (1 << (N-1))) begin
                mag_diff = (1 << (N-1)) - 1;
                sign_diff = sign_a;
            end else begin
                mag_diff = sum_mag[N-2:0];
                sign_diff = sign_a;
            end
        end else begin
            if (mag_a > mag_b) begin
                mag_diff = mag_a - mag_b;
                sign_diff = sign_a;
            end else if (mag_b > mag_a) begin
                mag_diff = mag_b - mag_a;
                sign_diff = sign_b;
            end else begin
                mag_diff = 0;
                sign_diff = 0;
            end
        end

        res = {sign_diff, mag_diff};
    end

    assign c = res;

endmodule
