
module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    localparam MUL2_DIV_CLK = 7;
  
    reg [2:0] cnt;
               
    reg clk_half_pos, clk_half_neg;
  

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_half_pos <= 0;
            clk_half_neg <= 0;
            clk_div <= 0;
        end else begin
            if (cnt < MUL2_DIV_CLK) begin
                if (cnt < 4) begin
                    clk_half_pos <= 1;
                    clk_half_neg <= 0;
                end else begin
                    clk_half_pos <= 0;
                    clk_half_neg <= 1;
                end
                cnt <= cnt + 1;
            end else begin
                cnt <= 0;
                clk_half_pos <= 0;
                clk_half_neg <= 0;
            end
        end
    end

    
    assign clk_div = clk_half_pos | clk_half_neg;

endmodule
