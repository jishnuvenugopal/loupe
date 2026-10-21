
module TopModule (
    input wire x,
    input wire y,
    output reg z
);

always @(posedge clk) begin
    z <= x & y;
end

endmodule
