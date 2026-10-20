
module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a == 0) begin
        q <= b;
    end
end

always @(posedge clk) begin
    state <= q;
end

endmodule
