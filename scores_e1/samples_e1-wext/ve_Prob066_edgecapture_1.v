
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg <= 32'b0;
        end else begin
            if (in != reg) begin
                reg <= in;
            end
        end
    end

    assign out = reg;

endmodule
