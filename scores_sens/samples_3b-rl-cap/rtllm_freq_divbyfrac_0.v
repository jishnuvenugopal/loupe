
module freq_divbyfrac (
    input        clk,
    input        rst_n,
    output reg   clk_div
);

    
    reg [2:0] counter;

    
    reg MUL2_DIV_CLK;
    reg MUL2_DIV_CLK2;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter   <= 3'b000;
            MUL2_DIV_CLK <= 1'b0;
            MUL2_DIV_CLK2 <= 1'b0;
            clk_div <= 1'b0;
        end else begin
            counter <= counter + 3'b001;

            
            if (counter == 3'b000) begin
                MUL2_DIV_CLK <= 1'b1;
            end else if (counter == 3'b001) begin
                MUL2_DIV_CLK <= 1'b0;
            end else if (counter == 3'b002) begin
                MUL2_DIV_CLK <= 1'b0;
            end else if (counter == 3'b003) begin
                MUL2_DIV_CLK <= 1'b0;
            end else if (counter == 3'b004) begin
                MUL2_DIV_CLK <= 1'b0;
            end else if (counter == 3'b005) begin
                MUL2_DIV_CLK <= 1'b0;
            end else if (counter == 3'b006) begin
                MUL2_DIV_CLK <= 1'b1;
            end else begin
                MUL2_DIV_CLK <= 1'b0;
            end

            
            if (counter == 3'b000) begin
                MUL2_DIV_CLK2 <= 1'b0;
            end else if (counter == 3'b001) begin
                MUL2_DIV_CLK2 <= 1'b0;
            end else if (counter == 3'b002) begin
                MUL2_DIV_CLK2 <= 1'b0;
            end else if (counter == 3'b003) begin
                MUL2_DIV_CLK2 <= 1'b0;
            end else if (counter == 3'b004) begin
                MUL2_DIV_CLK2 <= 1'b0;
            end else if (counter == 3'b005) begin
                MUL2_DIV_CLK2 <= 1'b1;
            end else if (counter == 3'b006) begin
                MUL2_DIV_CLK2 <= 1'b0;
            end else begin
                MUL2_DIV_CLK2 <= 1'b0;
            end

            
            clk_div <= MUL2_DIV_CLK | MUL2_DIV_CLK2;
        end
    end

endmodule
