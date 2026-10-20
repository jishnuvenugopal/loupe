
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] out_reg;

    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 0;
        end else begin
            out_reg <= 0;
            for (integer i = 0;
 i < 32;
 i = i + 1) begin
                if (in[i] && !in[i+1]) begin
                    out_reg[i] <= 1;
                end else begin
                    out_reg[i] <= 0;
                end
            end
        end
    end

    assign out = out_reg;

endmodule
