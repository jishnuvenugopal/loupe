
module freq_divbyfrac (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

    
    localparam MUL2_DIV_CLK = 7;
 
    localparam CLK_DIV_WIDTH = 3;
 

    
    reg [CLK_DIV_WIDTH-1:0] counter;
    reg clk_div_pos, clk_div_neg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_pos  <= 1'b0;
            clk_div_neg  <= 1'b0;
            clk_div      <= 1'b0;
        end else begin
            
            if (counter == 0) begin
                clk_div_pos  <= 1'b1;
                clk_div_neg  <= 1'b0;
                counter      <= counter + 1;
            end
            
            else if (counter == MUL2_DIV_CLK-1) begin
                clk_div_pos  <= 1'b0;
                clk_div_neg  <= 1'b1;
                counter      <= 0;
            end
            
            else begin
                clk_div_pos  <= clk_div_pos;
                clk_div_neg  <= clk_div_neg;
                counter      <= counter + 1;
            end
            
            clk_div <= clk_div_pos | clk_div_neg;
        end
    end

endmodule
