
module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_50, cnt_10, cnt_100;
reg [1:0] clk_50_next, clk_10_next, clk_100_next;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_50 <= 2'b00;
        cnt_10 <= 2'b00;
        cnt_100 <= 2'b00;
        clk_50_next <= 2'b00;
        clk_10_next <= 2'b00;
        clk_100_next <= 2'b00;
    end else begin
        clk_50_next <= cnt_50;
        clk_10_next <= cnt_10;
        clk_100_next <= cnt_100;

        if (cnt_50 == 2'b11) begin
            clk_50_next <= 2'b00;
        end else begin
            clk_50_next <= cnt_50 + 1'b1;
        end

        if (cnt_10 == 2'b11) begin
            clk_10_next <= 2'b00;
            cnt_10 <= 2'b00;
        end else begin
            cnt_10_next <= cnt_10 + 1'b1;
        end

        if (cnt_100 == 2'b11) begin
            clk_100_next <= 2'b00;
            cnt_100 <= 2'b00;
        end else begin
            cnt_100_next <= cnt_100 + 1'b1;
        end
    end
end

assign CLK_50 = clk_50_next;
assign CLK_10 = clk_10_next;
assign CLK_1 = clk_100_next;

endmodule
