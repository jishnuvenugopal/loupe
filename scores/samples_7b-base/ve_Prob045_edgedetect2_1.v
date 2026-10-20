
module TopModule (
    input wire clk,
    input wire [7:0] in,
    output reg [7:0] out
);

reg [7:0] in_reg;

always @(posedge clk) begin
    in_reg <= in;
end

always @(posedge clk) begin
    out <= 0;
    if (in[7] == 1'b0 && in_reg[7] == 1'b1) out[7] <= 1'b1;
    if (in[6] == 1'b0 && in_reg[6] == 1'b1) out[6] <= 1'b1;
    if (in[5] == 1'b0 && in_reg[5] == 1'b1) out[5] <= 1'b1;
    if (in[4] == 1'b0 && in_reg[4] == 1'b1) out[4] <= 1'b1;
    if (in[3] == 1'b0 && in_reg[3] == 1'b1) out[3] <= 1'b1;
    if (in[2] == 1'b0 && in_reg[2] == 1'b1) out[2] <= 1'b1;
    if (in[1] == 1'b0 && in_reg[1] == 1'b1) out[1] <= 1'b1;
    if (in[0] == 1'b0 && in_reg[0] == 1'b1) out[0] <= 1'b1;
end

endmodule
