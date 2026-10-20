
module TopModule (
    input wire clk,
    input wire a,
    input wire b,
    output reg q,
    output reg state
);

reg dff;

always @(posedge clk) begin
    dff <= a & b;
    state <= dff;
end

assign q = dff;

endmodule
