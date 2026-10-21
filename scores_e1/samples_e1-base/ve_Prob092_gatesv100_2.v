
module TopModule (
    input wire [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out_both <= 100'b0;
        out_any <= 100'b0;
        out_different <= 100'b0;
    end else begin
        out_both <= (in[99] & in[98]) ? 100'b1 : 100'b0;
        out_any <= (in[0] | in[1]) ? 100'b1 : 100'b0;
        out_different <= (in[99] != in[0]) ? 100'b1 : 100'b0;
    end
end

endmodule
