
module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

always @(posedge clk) begin
    q <= q >> 1;
    q[7] <= d;
end

endmodule
