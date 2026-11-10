
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg q
);

always @(*) begin
    if (a == 1) begin
        q <= 0;
    end else begin
        q <= 1;
    end
end

endmodule
