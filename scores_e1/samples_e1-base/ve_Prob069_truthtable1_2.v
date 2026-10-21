
module TopModule (
    input wire x3,
    input wire x1,
    output reg f
);

always @(x3, x1) begin
    f <= x3 | x1;
end

endmodule
