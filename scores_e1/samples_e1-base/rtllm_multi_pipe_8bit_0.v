
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg [15:0] mul_out,
    output reg mul_en_out
);

reg [15:0] mul_out_reg;
reg [1:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
wire [7:0] temp [0:7];
wire [7:0] sum [0:7];
reg [7:0] mul_out;

always @(posedge clk or posedge rst_n) begin
    if (rst_n == 1'b0) begin
        mul_out_reg <= 16'b0;
        mul_en_out_reg <= 2'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            temp[i] <= 8'b0;
            sum[i] <= 8'b0;
        end
    end else begin
        if (mul_en_in == 1'b1) begin
            mul_en_out_reg <= 2'b1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                if (mul_b[i] == 1'b1) begin
                    temp[i] <= mul_a_reg;
                end
            end
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                sum[i] <= temp[i] + sum[i];
            end
            mul_out_reg <= sum[7];
        end else begin
            mul_en_out_reg <= 2'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                temp[i] <= 8'b0;
                sum[i] <= 8'b0;
            end
        end
    end
end

always @(posedge clk or posedge rst_n) begin
    if (rst_n == 1'b0) begin
        mul_out <= 16'b0;
    end else begin
        if (mul_en_out_reg == 2'b1) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule
