
module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    
    reg [6:0] counter;
    
    reg clk_div_pos, clk_div_neg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 7'd0;
        else
            counter <= counter + 1'b1;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_pos <= 1'b0;
            clk_div_neg <= 1'b0;
        end else begin
            if (counter == 7'd0) begin
                clk_div_pos <= 1'b1;
                counter <= 7'd6;
            end else if (counter == 7'd6) begin
                clk_div_pos <= 1'b0;
                counter <= 7'd0;
            end else begin
                clk_div_pos <= 1'b0;
            end

            if (counter == 7'd6) begin
                clk_div_neg <= 1'b1;
            end else begin
                clk_div_neg <= 1'b0;
            end
        end
    end

    
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule
