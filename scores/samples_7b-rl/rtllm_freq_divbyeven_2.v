
module freq_divbyeven (
    input clk,
    input rst_n,
    output reg clk_div = 0
);

    parameter NUM_DIV = 6;
    
    reg [3:0] cnt;
    localparam integer cnt_limit = (NUM_DIV / 2) - 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt < cnt_limit) begin
                cnt <= cnt + 1;
            end else begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end
        end
    end

endmodule
