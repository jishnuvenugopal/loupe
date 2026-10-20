
module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count_reg;

assign q = count_reg;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'b0;
    end else begin
        if (slowena) begin
            if (count_reg == 4'd9)
                count_reg <= 4'd0;
            else
                count_reg <= count_reg + 4'd1;
        end
    end
end

endmodule
