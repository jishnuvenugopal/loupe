
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg carry;

assign z = (~x) ^ carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        carry <= 1'b1;
    end else begin
        carry <= (~x) & carry;
    end
end

endmodule
