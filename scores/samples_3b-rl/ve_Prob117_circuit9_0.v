
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    reg [2:0] q_reg;

    always @(posedge clk) begin
        if (a) begin
            q_reg <= q_reg + 1;
        end else begin
            q_reg <= 3'b004;
        end
    end

    assign q = q_reg;

endmodule
