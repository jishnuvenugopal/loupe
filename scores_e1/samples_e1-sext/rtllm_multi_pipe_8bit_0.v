
module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg [15:0] mul_out,
    output reg mul_en_out
);

reg [7:0] mul_a_reg, mul_b_reg;
reg [7:0] temp[0:7];
reg [15:0] sum[0:7];
reg [15:0] mul_out_reg;
reg [15:0] sum_reg;
reg [15:0] mul_out;

always @(posedge clk or posedge rst_n) begin
    if (rst_n == 1'b0) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        temp <= {8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0};
        sum <= {16'b0, 16'b0, 16'b0, 16'b0, 16'b0, 16'b0, 16'b0, 16'b0};
        mul_out_reg <= 16'b0;
        sum_reg <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        if (mul_en_in == 1'b1) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            temp[0] <= mul_a_reg[0] & mul_b_reg[0];
            temp[1] <= mul_a_reg[0] & mul_b_reg[1];
            temp[2] <= mul_a_reg[0] & mul_b_reg[2];
            temp[3] <= mul_a_reg[0] & mul_b_reg[3];
            temp[4] <= mul_a_reg[0] & mul_b_reg[4];
            temp[5] <= mul_a_reg[0] & mul_b_reg[5];
            temp[6] <= mul_a_reg[0] & mul_b_reg[6];
            temp[7] <= mul_a_reg[0] & mul_b_reg[7];
            sum[0] <= temp[0] + temp[1];
            sum[1] <= temp[2] + temp[3];
            sum[2] <= temp[4] + temp[5];
            sum[3] <= temp[6] + temp[7];
            sum[4] <= sum[0] + sum[1];
            sum[5] <= sum[2] + sum[3];
            sum[6] <= sum[4] + sum[5];
            sum[7] <= sum[6] + sum[7];
            mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];
            mul_en_out <= 1'b1;
        end else begin
            mul_en_out <= 1'b0;
        end
    end
end

always @(posedge clk or posedge rst_n) begin
    if (rst_n == 1'b0) begin
        mul_out <= 16'b0;
    end else begin
        mul_out <= mul_out_reg;
    end
end

endmodule
