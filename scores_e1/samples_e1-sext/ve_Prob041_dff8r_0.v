
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    reg [7:0] d_reg;
    reg [7:0] q_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            d_reg <= 8'b0;
            q_reg <= 8'b0;
        end else begin
            d_reg <= d;
            q_reg <= d_reg;
        end
    end

    assign q = q_reg;

endmodule
