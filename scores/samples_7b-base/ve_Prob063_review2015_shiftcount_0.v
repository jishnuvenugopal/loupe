
module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] shift_reg;
reg [3:0] count_reg;


always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
    end
end


always @(posedge clk) begin
    if (count_ena) begin
        count_reg <= count_reg - 1;
    end
end


always @(posedge clk) begin
    if (shift_ena) begin
        q <= shift_reg;
    end else if (count_ena) begin
        q <= count_reg;
    end
end

endmodule
