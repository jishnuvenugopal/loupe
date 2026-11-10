
module TopModule (
    input wire d,
    input wire ena,
    output reg q
);

always @(posedge ena or posedge d) begin
    q <= d;
end

endmodule
