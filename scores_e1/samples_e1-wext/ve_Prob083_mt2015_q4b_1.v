
module TopModule (
    input wire x,
    input wire y,
    output reg z
);

always @(x, y) begin
    if (x == 0 && y == 0) begin
        z = 1;
    end else begin
        z = 0;
    end
end

endmodule
