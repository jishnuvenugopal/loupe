
module TopModule (
    input wire [31:0] in,
    output reg [31:0] out
);

always @(*) begin
    out = in[7:0] << 24 | in[15:8] << 16 | in[23:16] << 8 | in[31:24];
end

endmodule
