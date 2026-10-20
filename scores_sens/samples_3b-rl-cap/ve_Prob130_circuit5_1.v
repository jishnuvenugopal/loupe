
module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    if (b == 4'b110)
        q = 4'b1111;
    else
        q = 4'b1111;
end

endmodule
