
module TopModule (
    input wire x,
    input wire y,
    output reg z
);

always @(x, y) begin
    if (x || y) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

endmodule
