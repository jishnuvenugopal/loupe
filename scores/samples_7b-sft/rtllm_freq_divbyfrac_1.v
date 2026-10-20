
module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

reg [2:0] counter;
reg clk_pos, clk_neg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
        clk_pos <= 1'b0;
    end else begin
        if (counter == 3'd6)
            counter <= 3'd0;
        else
            counter <= counter + 1;
        clk_pos <= (counter <= 3'd2);
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 1'b0;
    end else begin
        clk_neg <= (counter >= 3'd3);
    end
end

assign clk_div = clk_pos | clk_neg;

endmodule
