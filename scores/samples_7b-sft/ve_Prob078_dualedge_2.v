
module TopModule (
    input clk,
    input d,
    output q
);

reg pos_reg, neg_reg;

always @(posedge clk) begin
    pos_reg <= d;
end

always @(negedge clk) begin
    neg_reg <= d;
end

assign q = clk ? pos_reg : neg_reg;

endmodule
