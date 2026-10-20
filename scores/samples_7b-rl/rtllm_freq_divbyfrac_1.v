
module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);
    reg [2:0] cnt;
    reg clk1;
    reg clk2;
    
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk1 <= 1'b0;
        end else begin
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;
            
            clk1 <= (cnt <= 3'd2);
        end
    end
    
    
    reg [2:0] cnt_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk2 <= 1'b0;
        end else begin
            if (cnt_neg == 3'd6)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;
            
            clk2 <= (cnt_neg >= 3'd3);
        end
    end
    
    assign clk_div = clk1 | clk2;
endmodule
