
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

always @(posedge clk) begin
    if (areset) begin
        z <= 1'b0;
    end else begin
        if (x == 1'b0) begin
            z <= ~z + 1'b1;
        end else begin
            z <= {z, x};
        end
    end
end

endmodule
