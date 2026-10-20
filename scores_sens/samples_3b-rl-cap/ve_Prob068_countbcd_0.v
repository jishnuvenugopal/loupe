
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
        if (ena[0]) begin
            if (q[3] == 1'b1) begin
                q[3] <= 1'b0;
            end else begin
                q[3] <= 1'b1;
            end
        end
        if (ena[1]) begin
            if (q[7] == 1'b1) begin
                q[7] <= 1'b0;
            end else begin
                q[7] <= 1'b1;
            end
        end
        if (ena[2]) begin
            if (q[11] == 1'b1) begin
                q[11] <= 1'b0;
            end else begin
                q[11] <= 1'b1;
            end
        end
        if (ena[3]) begin
            if (q[15] == 1'b1) begin
                q[15] <= 1'b0;
            end else begin
                q[15] <= 1'b1;
            end
        end
    end
end

endmodule
