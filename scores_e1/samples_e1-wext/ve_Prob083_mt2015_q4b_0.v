
module TopModule (
    input  x,
    input  y,
    output z
);

always @(*) begin
    if (x == 0 && y == 0) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

endmodule
