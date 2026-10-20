
module TopModule (
    input clock,
    input a,
    output p,
    output q
);

    reg q_reg, p_reg;

    always @(posedge clock) begin
        p_reg <= ~p_reg;
        if (a) begin
            q_reg <= 1;
        end else begin
            q_reg <= 0;
        end
    end

    assign p = p_reg;
    assign q = q_reg;

endmodule
