
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
    reg [15:0] temp[0:7];
    reg [15:0] sum[0:7];
    reg [15:0] mul_out_reg;
    reg [15:0] mul_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            mul_out_reg <= 16'b0;
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out <= mul_en_in;

            for (int i = 0;
 i < 8;
 i++) begin
                temp[i] <= mul_a_reg[i] * mul_b_reg[i];
            end

            for (int i = 0;
 i < 8;
 i++) begin
                sum[i] <= sum[i] + temp[i];
            end

            mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];
            mul_out <= mul_out_reg;
        end
    end

endmodule
