
module TopModule (
    input wire x3,
    input wire x2,
    input wire x1,
    output reg f
);

always @(*) begin
    if (x3 == 1 && x1 == 1) begin
        f = 1'b1;
    end else begin
        f = 1'b0;
    end
end

endmodule
