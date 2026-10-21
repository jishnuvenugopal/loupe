
module TopModule (
    input wire [254:0] in,
    output reg [7:0] out
);

    always @(posedge clk) begin
        out <= 8'b0;
        for (int i = 0;
 i < 32;
 i++) begin
            out[i] <= (in[i] & 0x55) + ((in[i] >> 1) & 0x55);
        end
    end

endmodule
