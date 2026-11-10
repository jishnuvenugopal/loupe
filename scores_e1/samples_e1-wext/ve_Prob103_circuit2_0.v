
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg q
);

always @(a, b, c, d) begin
    if (a == 0 && b == 0 && c == 0) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule
