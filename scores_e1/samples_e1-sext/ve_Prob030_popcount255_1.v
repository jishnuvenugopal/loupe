
module TopModule (
    input wire [254:0] in,
    output reg [7:0] out
);

always @(*) begin
    out = 8'b0;
    for (genvar i = 0;
 i < 32;
 i = i + 8) begin
        out = out + (in[i+7:i] == 8'b11111111);
    end
end

endmodule
