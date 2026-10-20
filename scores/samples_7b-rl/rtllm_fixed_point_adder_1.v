
module fixed_point_adder #(
    parameter Q = 8,
    parameter N = 16
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1) : b[N-2:0];

    always @* begin
        if (a_sign == b_sign) begin
            res = {a_sign, a_mag + b_mag};
        end else begin
            if (a_mag > b_mag) begin
                res = {a_sign, a_mag - b_mag};
            end else if (b_mag > a_mag) begin
                res = {b_sign, b_mag - a_mag};
            end else begin
                res = {1'b0, {(N-2){1'b0}}};
            end
        end
    end

    assign c = res;

endmodule
