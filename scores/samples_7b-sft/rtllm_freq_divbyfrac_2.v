
module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

reg [2:0] pos_counter;
reg [2:0] neg_counter;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_counter <= 3'd0;
    end else begin
        pos_counter <= (pos_counter == 3'd6) ? 3'd0 : pos_counter + 3'd1;
    end
end


always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_counter <= 3'd0;
    end else begin
        neg_counter <= (neg_counter == 3'd6) ? 3'd0 : neg_counter + 3'd1;
    end
end


wire pos_pulse = (pos_counter <= 3'd2);
wire neg_pulse = (neg_counter >= 3'd3);


assign clk_div = pos_pulse | neg_pulse;

endmodule
