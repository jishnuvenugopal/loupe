
module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

reg clk_50_reg;
reg clk_10_reg;
reg clk_1_reg;


always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        clk_50_reg <= 1'b0;
    end else begin
        clk_50_reg <= ~clk_50_reg;
    end
end


reg [2:0] cnt_10;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_10 <= 3'd0;
        clk_10_reg <= 1'b0;
    end else begin
        if (cnt_10 == 3'd4) begin
            clk_10_reg <= ~clk_10_reg;
            cnt_10 <= 3'd0;
        end else begin
            cnt_10 <= cnt_10 + 3'd1;
        end
    end
end


reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_100 <= 6'd0;
        clk_1_reg <= 1'b0;
    end else begin
        if (cnt_100 == 6'd49) begin
            clk_1_reg <= ~clk_1_reg;
            cnt_100 <= 6'd0;
        end else begin
            cnt_100 <= cnt_100 + 6'd1;
        end
    end
end

assign CLK_50 = clk_50_reg;
assign CLK_10 = clk_10_reg;
assign CLK_1 = clk_1_reg;

endmodule
