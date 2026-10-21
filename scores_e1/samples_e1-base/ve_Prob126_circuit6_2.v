
module TopModule (
    input  [2:0] a,
    output reg [15:0] q
);

always @(posedge a) begin
    q <= q + 1'b1;
end

endmodule
