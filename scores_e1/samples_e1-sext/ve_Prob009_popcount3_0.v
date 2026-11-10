
module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);

always @(*) begin
    out = 2'b0;
    for (int i = 0;
 i < 3;
 i++) begin
        if (in[i] == 1'b1) begin
            out = out + 1'b1;
        end
    end
end

endmodule
