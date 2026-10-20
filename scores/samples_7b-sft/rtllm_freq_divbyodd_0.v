
module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input clk,
    input rst_n,
    output clk_div
);

localparam CNT_WIDTH = $clog2(NUM_DIV);
reg [CNT_WIDTH-1:0] cnt1;
reg [CNT_WIDTH-1:0] cnt2;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
    end else begin
        cnt1 <= (cnt1 == NUM_DIV - 1) ? 0 : cnt1 + 1;
    end
end


always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
    end else begin
        cnt2 <= (cnt2 == NUM_DIV - 1) ? 0 : cnt2 + 1;
    end
end


wire clk_div1 = (cnt1 < ((NUM_DIV + 1)/2));
wire clk_div2 = (cnt2 < ((NUM_DIV + 1)/2));


assign clk_div = clk_div1 | clk_div2;

endmodule
