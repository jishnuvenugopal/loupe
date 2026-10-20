
module freq_divbyfrac(
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    
    localparam MUL2_DIV_CLK = 7;
 

    
    reg [MUL2_DIV_CLK-1:0] counter;
    reg [MUL2_DIV_CLK-1:0] half_clk;
    reg [MUL2_DIV_CLK-1:0] half_clk_adjusted;
    reg [MUL2_DIV_CLK-1:0] half_clk_or;

    
    always @(posedge rst_n or negedge clk) begin
        if (!rst_n) begin
            counter <= 0;
            half_clk <= 0;
            half_clk_adjusted <= 0;
            half_clk_or <= 0;
        end else begin
            counter <= counter + 1;
            half_clk <= counter[MUL2_DIV_CLK-1];
            half_clk_adjusted <= counter[MUL2_DIV_CLK-1];
            half_clk_or <= half_clk | half_clk_adjusted;
        end
    end

    
    always @(posedge clk) begin
        if (half_clk_or) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end

endmodule
