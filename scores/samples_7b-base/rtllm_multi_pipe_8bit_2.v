
module multi_pipe_8bit (
    input wire clk,        
    input wire rst_n,      
    input wire mul_en_in,  
    input wire [7:0] mul_a, 
    input wire [7:0] mul_b, 
    output reg mul_en_out, 
    output reg [15:0] mul_out 
);


reg mul_en_in_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;


reg [15:0] temp [0:7];


reg [15:0] sum [0:7];


reg [15:0] mul_out_reg;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_in_reg <= 1'b0;
    end else begin
        mul_en_in_reg <= mul_en_in;
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in_reg) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end


assign temp[0] = mul_a_reg[0] ? mul_b_reg << 0 : 16'b0;
assign temp[1] = mul_a_reg[1] ? mul_b_reg << 1 : 16'b0;
assign temp[2] = mul_a_reg[2] ? mul_b_reg << 2 : 16'b0;
assign temp[3] = mul_a_reg[3] ? mul_b_reg << 3 : 16'b0;
assign temp[4] = mul_a_reg[4] ? mul_b_reg << 4 : 16'b0;
assign temp[5] = mul_a_reg[5] ? mul_b_reg << 5 : 16'b0;
assign temp[6] = mul_a_reg[6] ? mul_b_reg << 6 : 16'b0;
assign temp[7] = mul_a_reg[7] ? mul_b_reg << 7 : 16'b0;


assign sum[0] = temp[0];
assign sum[1] = sum[0] + temp[1];
assign sum[2] = sum[1] + temp[2];
assign sum[3] = sum[2] + temp[3];
assign sum[4] = sum[3] + temp[4];
assign sum[5] = sum[4] + temp[5];
assign sum[6] = sum[5] + temp[6];
assign sum[7] = sum[6] + temp[7];


assign mul_out_reg = sum[7];


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        mul_en_out <= mul_en_in_reg;
        mul_out <= mul_out_reg;
    end
end

endmodule
