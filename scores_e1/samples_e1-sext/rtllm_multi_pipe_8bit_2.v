
module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg [15:0] mul_out,
    output reg mul_en_out
);

reg [1:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] temp;
reg [15:0] sum;
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 2'b00;
        mul_a_reg <= 8'b00000000;
        mul_b_reg <= 8'b00000000;
        temp <= 16'b0000000000000000;
        sum <= 16'b0000000000000000;
        mul_out_reg <= 16'b0000000000000000;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= mul_en_in;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        for (int i = 0;
 i < 8;
 i++) begin
            if (mul_b_reg[i] == 1'b1) begin
                temp[i] <= mul_a_reg;
            end else begin
                temp[i] <= 8'b00000000;
            end
        end
        for (int i = 0;
 i < 8;
 i++) begin
            if (i == 0) begin
                sum <= temp[i];
            end else begin
                sum <= sum + temp[i];
            end
        end
        mul_out_reg <= sum;
    end
end

assign mul_en_out = mul_en_out_reg[1];
assign mul_out = mul_out_reg[0];

endmodule
