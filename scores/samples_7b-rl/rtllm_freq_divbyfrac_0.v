
module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

    reg [2:0] pos_count;
    reg [2:0] neg_count;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pos_count <= 3'd0;
        else
            pos_count <= (pos_count == 3'd6) ? 3'd0 : pos_count + 3'd1;
    end

    
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            neg_count <= 3'd0;
        else
            neg_count <= (neg_count == 3'd6) ? 3'd0 : neg_count + 3'd1;
    end

    
    wire pos_pulse = (pos_count < 3'd3);
    wire neg_pulse = (neg_count >= 3'd3);

    
    assign clk_div = pos_pulse | neg_pulse;

endmodule
