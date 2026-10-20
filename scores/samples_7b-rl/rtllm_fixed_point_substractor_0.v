
module fixed_point_subtractor #(
    parameter Q = 8,
    parameter N = 16
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

    reg signed [N-1:0] a_signed, b_signed, res;

    always @* begin
        a_signed = a;
        b_signed = b;
        res = a_signed - b_signed;

        
        if (res == 0)
            res = 0;
    end

    assign c = res;

endmodule
