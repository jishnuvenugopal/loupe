
module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk or posedge r) begin
    if (r == 1) begin
        q <= 0;
    end else begin
        q <= d;
    end
end

endmodule
