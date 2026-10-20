
module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'd1;
    end else begin
        if (q_reg == 4'd10)
            q_reg <= 4'd1;
        else
            q_reg <= q_reg + 4'd1;
    end
end

assign q = q_reg;

endmodule
