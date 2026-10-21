
module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (L) begin
            q <= r;
        end else begin
            q <= {q[1] ^ q[2], q[0], q[2]};
        end
    end

endmodule
