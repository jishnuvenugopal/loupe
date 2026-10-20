
module TopModule (
    input  wire clock,
    input  wire a,
    output reg  p,
    output reg  q
);

    reg p_reg, q_reg;

    always @(posedge clock) begin
        if (a == 1'b0) begin
            p_reg <= ~p_reg;
            q_reg <= 1'b0;
        end else begin
            p_reg <= 1'b0;
            q_reg <= ~q_reg;
        end
    end

    assign p = p_reg;
    assign q = q_reg;

endmodule
