
module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    
    reg [2:0] counter;
    reg [2:0] MUL2_DIV_CLK;

    
    reg [2:0] clk_div_pos;
    reg [2:0] clk_div_neg;

    
    always @(posedge rst_n or negedge clk) begin
        if (!rst_n) begin
            counter <= 3'b000;
            MUL2_DIV_CLK <= 3'b000;
            clk_div_pos <= 3'b000;
            clk_div_neg <= 3'b000;
            clk_div <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
            MUL2_DIV_CLK <= counter;
        end
    end

    
    always @(posedge clk) begin
        if (counter == 3'b000) begin
            clk_div_pos <= 3'b001;
        end else if (counter == 3'b001) begin
            clk_div_pos <= 3'b010;
        end else if (counter == 3'b002) begin
            clk_div_pos <= 3'b011;
        end else if (counter == 3'b003) begin
            clk_div_pos <= 3'b100;
        end else if (counter == 3'b004) begin
            clk_div_pos <= 3'b101;
        end else if (counter == 3'b005) begin
            clk_div_pos <= 3'b110;
        end else if (counter == 3'b006) begin
            clk_div_pos <= 3'b111;
        end else if (counter == 3'b007) begin
            clk_div_pos <= 3'b000;
        end
    end

    always @(negedge clk) begin
        if (counter == 3'b000) begin
            clk_div_neg <= 3'b001;
        end else if (counter == 3'b001) begin
            clk_div_neg <= 3'b010;
        end else if (counter == 3'b002) begin
            clk_div_neg <= 3'b011;
        end else if (counter == 3'b003) begin
            clk_div_neg <= 3'b100;
        end else if (counter == 3'b004) begin
            clk_div_neg <= 3'b101;
        end else if (counter == 3'b005) begin
            clk_div_neg <= 3'b110;
        end else if (counter == 3'b006) begin
            clk_div_neg <= 3'b111;
        end else if (counter == 3'b007) begin
            clk_div_neg <= 3'b000;
        end
    end

    
    always @(posedge clk or negedge clk) begin
        if (rst_n) begin
            clk_div <= 3'b000;
        end else begin
            clk_div <= clk_div_pos | clk_div_neg;
        end
    end

endmodule
