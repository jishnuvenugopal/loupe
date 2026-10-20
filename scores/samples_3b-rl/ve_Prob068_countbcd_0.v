
module TopModule (
    input clk,
    input reset,
    output reg [3:0] ena,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 16'b0;
        ena <= 4'b0;
    end else begin
        if (ena[0])
            q[3:0] <= q[3:0] + 4'b1;
        if (ena[1])
            q[7:4] <= q[7:4] + 4'b1;
        if (ena[2])
            q[11:8] <= q[11:8] + 4'b1;
        if (ena[3])
            q[15:12] <= q[15:12] + 4'b1;
    end
end

endmodule
