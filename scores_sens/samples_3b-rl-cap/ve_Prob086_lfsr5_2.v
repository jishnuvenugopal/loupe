
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b11111;
    end else begin
        q[4] <= q[5] ^ q[3];
        q[3:0] <= q[4:1];
    end
end

endmodule
