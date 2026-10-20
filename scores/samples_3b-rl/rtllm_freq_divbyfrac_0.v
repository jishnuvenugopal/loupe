
module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    
    reg [6:0] counter;
    reg MUL2_DIV_CLK;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 7'd0;
        else begin
            counter <= counter + 1'b1;
            if (counter == 7'd6)
                counter <= 7'd0;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            MUL2_DIV_CLK <= 1'b0;
        else begin
            if (counter == 7'd0)
                MUL2_DIV_CLK <= 1'b1;
            else
                MUL2_DIV_CLK <= 1'b0;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 1'b0;
        else begin
            clk_div <= MUL2_DIV_CLK;
        end
    end

endmodule
