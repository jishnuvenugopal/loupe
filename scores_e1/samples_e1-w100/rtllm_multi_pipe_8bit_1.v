
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg [15:0] mul_out,
    output reg mul_en_out
);

    reg [1:0] mul_en_out_reg;
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg [15:0] temp;
    reg [15:0] sum;
    reg [15:0] mul_out_reg;

    always @(posedge clk or posedge rst_n) begin
        if (rst_n == 1'b0) begin
            mul_en_out_reg <= 2'b00;
            mul_a_reg <= 8'b00000000;
            mul_b_reg <= 8'b00000000;
            temp <= 16'b0000000000000000;
            sum <= 16'b0000000000000000;
            mul_out_reg <= 16'b0000000000000000;
        end else begin
            if (mul_en_in == 1'b1) begin
                mul_en_out_reg <= 2'b01;
            end else begin
                mul_en_out_reg <= 2'b00;
            end

            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;

            for (int i = 0;
 i < 8;
 i++) begin
                if (mul_b_reg[i] == 1'b1) begin
                    temp[i] <= mul_a_reg[i];
                end else begin
                    temp[i] <= 8'b00000000;
                end
            end

            for (int i = 0;
 i < 8;
 i++) begin
                if (temp[i] == 8'b10000000) begin
                    sum[i] <= sum[i] + 1'b1;
                end
            end

            for (int i = 0;
 i < 8;
 i++) begin
                if (sum[i] == 1'b10000000) begin
                    sum[i] <= sum[i] + 1'b1;
                end
            end

            mul_out_reg <= sum;
        end
    end

    always @(posedge clk or posedge rst_n) begin
        if (rst_n == 1'b0) begin
            mul_out <= 16'b0000000000000000;
        end else begin
            if (mul_en_out_reg == 2'b01) begin
                mul_out <= mul_out_reg;
            end else begin
                mul_out <= 16'b0000000000000000;
            end
        end
    end

endmodule
