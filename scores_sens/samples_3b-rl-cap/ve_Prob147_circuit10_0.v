
module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    reg q_reg;
    reg state_reg;

    always @(posedge clk) begin
        q_reg <= a & b;
        state_reg <= q_reg;
    end

    assign q = q_reg;
    assign state = state_reg;

endmodule
