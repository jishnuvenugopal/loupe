
module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

always @(x3, x2, x1) begin
    if (x3 == 1 && x1 == 1) begin
        f = 1'b1;
    end else begin
        f = 1'b0;
    end
end

endmodule
