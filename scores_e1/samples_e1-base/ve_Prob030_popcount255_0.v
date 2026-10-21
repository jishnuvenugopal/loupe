
module TopModule (
    input wire [254:0] in,
    output reg [7:0] out
);

always @(posedge clk or negedge rst) begin
    if (rst) begin
        out <= 8'b0;
    end else begin
        out <= 8'b0;
        for (int i = 0;
 i < 255;
 i = i + 1) begin
            out <= out + in[i];
        end
    end
end

endmodule
