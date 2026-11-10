
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

always @(*) begin
    for (int i = 0;
 i < 25;
 i = i + 1) begin
        out[i] = ~a ^ b ^ c ^ d ^ e;
    end
end

endmodule
