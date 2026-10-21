
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg [15:0] mul_out,
    output reg mul_en_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [7:0] temp [0:7];
reg [15:0] sum [0:7];
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        temp <= 8'b0;
        sum <= 8'b0;
        mul_out_reg <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            temp <= 8'b0;
            sum <= 8'b0;
            mul_out_reg <= 16'b0;
            mul_en_out <= 1'b1;
        end else begin
            mul_en_out <= 1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        temp <= 8'b0;
        sum <= 8'b0;
        mul_out_reg <= 16'b0;
    end else begin
        if (mul_en_out) begin
            for (int i = 0;
 i < 8;
 i++) begin
                if (mul_b_reg[i] == 1'b1) begin
                    temp[i] <= mul_a_reg;
                end else begin
                    temp[i] <= 8'b0;
                end
            end
            for (int i = 0;
 i < 8;
 i++) begin
                sum[i] <= temp[i] + sum[i];
            end
            mul_out_reg <= sum[7];
        end else begin
            mul_out_reg <= 16'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
    end else begin
        if (mul_en_out) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule
