
module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    
    localparam COUNTER_WIDTH = 3;
    reg [COUNTER_WIDTH-1:0] counter;

    
    reg MUL2_DIV_CLK1;
    reg MUL2_DIV_CLK2;

    
    initial begin
        counter = 0;
        MUL2_DIV_CLK1 = 0;
        MUL2_DIV_CLK2 = 0;
        clk_div = 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            MUL2_DIV_CLK1 <= 0;
            MUL2_DIV_CLK2 <= 0;
            clk_div <= 0;
        end else begin
            
            counter <= counter + 1;

            
            if (counter == 0) begin
                MUL2_DIV_CLK1 <= 1;
                counter <= counter + 1;
            end else if (counter == 7) begin
                MUL2_DIV_CLK2 <= 1;
                counter <= 0;
            end else begin
                MUL2_DIV_CLK1 <= 0;
                MUL2_DIV_CLK2 <= 0;
            end
        end
    end

    
    assign clk_div = MUL2_DIV_CLK1 | MUL2_DIV_CLK2;

endmodule
