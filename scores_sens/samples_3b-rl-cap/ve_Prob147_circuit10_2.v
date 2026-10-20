
module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

always @(posedge clk) begin
    state <= a;
    q <= b;
end

endmodule
