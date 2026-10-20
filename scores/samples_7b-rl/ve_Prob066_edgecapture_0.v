
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] detect;

    assign detect = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'd0;
            prev_in <= in;
        end else begin
            prev_in <= in;
            out <= out | detect;
        end
    end

endmodule
