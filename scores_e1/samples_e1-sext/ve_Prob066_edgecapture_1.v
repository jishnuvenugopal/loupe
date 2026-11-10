
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        reg <= 32'b0;
        out <= 32'b0;
    end else begin
        reg <= in;
        if (reg != in) begin
            out <= 32'b1;
        end else begin
            out <= reg;
        end
    end
end

endmodule
