
module freq_divbyodd #(parameter NUM_DIV = 5) (
    input clk,
    input rst_n,
    output clk_div
);

localparam HALF_COUNT = (NUM_DIV + 1) / 2;
reg [31:0] cnt1, cnt2;
reg clk_div1, clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 1'b1;
    end else begin
        cnt1 <= (cnt1 == NUM_DIV - 1) ? 0 : cnt1 + 1;
        clk_div1 <= (cnt1 < HALF_COUNT) ? 1'b1 : 1'b0;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 1'b1;
    end else begin
        cnt2 <= (cnt2 == NUM_DIV - 1) ? 0 : cnt2 + 1;
        clk_div2 <= (cnt2 < HALF_COUNT) ? 1'b1 : 1'b0;
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule
