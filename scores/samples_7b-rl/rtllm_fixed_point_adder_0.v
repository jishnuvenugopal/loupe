
module fixed_point_adder #(
    parameter N = 8,
    parameter Q = 4
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

    
    reg signed [N-1:0] res;

    
    always @* begin
        res = $signed(a) + $signed(b);
    end

    
    assign c = res;

endmodule
