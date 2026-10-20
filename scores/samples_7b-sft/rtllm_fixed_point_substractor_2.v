
module fixed_point_subtractor #(
    parameter Q = 4,
    parameter N = 8
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;

    always @* begin
        res = a - b;
        c = res;
        
        if (c == 0) begin
            c[N-1] = 1'b0;
        end
    end

endmodule
