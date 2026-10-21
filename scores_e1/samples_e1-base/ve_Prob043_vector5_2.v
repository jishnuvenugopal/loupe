
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            out <= 25'b0;
        end else begin
            out <= 25'b0;
            for (int i = 0;
 i < 25;
 i++) begin
                out[i] <= ~a ^ b ^ c ^ d ^ e;
            end
        end
    end

endmodule
