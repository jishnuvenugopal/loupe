
module TopModule(
    input [254:0] in,
    output reg [7:0] out
);

reg [7:0] popcount;

always @(in) begin
    popcount = 0;
    for (int i = 0;
 i < 255;
 i = i + 1) begin
        if (in[i] == 1'b1) begin
            popcount = popcount + 1;
        end
    end
    out = popcount;
end

endmodule
