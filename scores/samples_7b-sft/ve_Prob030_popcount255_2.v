
module TopModule (
    input [254:0] in,
    output reg [7:0] out
);

reg [7:0] sum;

always @* begin
    sum = 0;
    for (integer i = 0;
 i < 255;
 i = i + 1) begin
        sum = sum + in[i];
    end
    out = sum;
end

endmodule
