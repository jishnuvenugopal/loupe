
module freq_divbyfrac #(parameter MUL2_DIV_CLK = 7) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [1:0] half_clk_cnt;
reg div_clk_pos;
reg div_clk_neg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        half_clk_cnt <= 2'b00;
        div_clk_pos <= 1'b0;
        div_clk_neg <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        half_clk_cnt <= half_clk_cnt + 1;
        if (half_clk_cnt == MUL2_DIV_CLK - 1) begin
            div_clk_pos <= 1'b1;
            div_clk_neg <= 1'b1;
            half_clk_cnt <= 2'b00;
        end else if (half_clk_cnt == MUL2_DIV_CLK - 4) begin
            div_clk_neg <= 1'b0;
        end else if (half_clk_cnt == MUL2_DIV_CLK - 3) begin
            div_clk_pos <= 1'b0;
        end

        clk_div <= div_clk_pos | div_clk_neg;
    end
end

endmodule
