
module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input clk,
    input rst_n,
    output clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam THRESHOLD = (NUM_DIV - 1) / 2;

    reg [CNT_WIDTH-1:0] cnt1, cnt2;
    reg clk_div1, clk_div2;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 1;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            clk_div1 <= ((cnt1 == NUM_DIV - 1) ? 0 : cnt1 + 1) < THRESHOLD ? 1 : 0;
        end
    end

    
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 1;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            clk_div2 <= ((cnt2 == NUM_DIV - 1) ? 0 : cnt2 + 1) < THRESHOLD ? 1 : 0;
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule
