
module TopModule (
    input [254:0] in,
    output reg [7:0] out
);

reg [254:0] count;

always @(*) begin
    count = 0;
    for (integer i = 0;
 i < 255;
 i = i + 1) begin
        count = count + (in[i] ? 1 : 0);
    end
    out = count[7:0];
end

endmodule
