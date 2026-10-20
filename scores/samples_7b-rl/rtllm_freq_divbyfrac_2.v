
module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

    reg [2:0] pos_cnt;
  
    reg [2:0] neg_cnt;
  
    reg clk1;
           
    reg clk2;
           

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 3'd0;
            clk1 <= 1'b0;
        end else begin
            
            pos_cnt <= (pos_cnt == 3'd6) ? 3'd0 : pos_cnt + 3'd1;
            
            clk1 <= (pos_cnt < 3'd3);
        end
    end

    
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 3'd0;
            clk2 <= 1'b0;
        end else begin
            
            neg_cnt <= (neg_cnt == 3'd6) ? 3'd0 : neg_cnt + 3'd1;
            
            clk2 <= (neg_cnt < 3'd3);
        end
    end

    
    assign clk_div = clk1 | clk2;

endmodule
