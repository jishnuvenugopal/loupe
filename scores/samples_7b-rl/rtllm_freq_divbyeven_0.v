
module freq_divbyeven #(
    parameter NUM_DIV = 6
) (
    input clk,
    input rst_n,
    output reg clk_div
);

    reg [3:0] cnt;
    localparam integer LIMIT = (NUM_DIV / 2) - 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt < LIMIT) begin
                cnt <= cnt + 1;
            end else begin
                cnt <= 4'd0;
                clk_div <= ~clk_div;
            end
        end
    end

endmodule
