
module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    q <= a & b;
    state <= q;
end



endmodule
