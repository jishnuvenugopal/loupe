
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            for (i = 0;
 i < 32;
 i = i + 1) begin
                if (in[i] & ~in[i+1])
                    out[i] <= 1'b1;
                else
                    out[i] <= 1'b0;
            end
        end
    end

endmodule
