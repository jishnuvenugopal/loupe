
module TopModule (
    input           clk,
    input  [7:0]    in,
    input  [7:0]    anyedge,
    output reg [7:0] out
);

reg  [15:0] state_reg;
reg  [15:0] temp_reg;

always @(posedge clk) begin
    temp_reg = state_reg;

    for (int i = 0;
 i < 8;
 i = i + 1) begin
        if (anyedge[i]) begin
            if (in[i] == 1'b0 && in[i-1] == 1'b1) begin
                temp_reg[i] = 1'b1;
            end else begin
                temp_reg[i] = 1'b0;
            end
        end
    end

    state_reg <= temp_reg;
    out <= temp_reg >> 8;
end

endmodule
