
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        z <= 1'b0;
    end else begin
        z <= ~x + 1'b1;
    end
end

endmodule
