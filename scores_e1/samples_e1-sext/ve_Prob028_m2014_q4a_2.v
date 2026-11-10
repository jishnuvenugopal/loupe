
module TopModule (
    input wire d,
    input wire ena,
    output reg q
);

always @(posedge ena or posedge d) begin
    if (ena) begin
        q <= d;
    end
end

endmodule
