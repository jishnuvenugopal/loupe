
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg, mul_b_reg;
reg [2:0] mul_en_out_reg;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 3'b0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        mul_en_out_reg <= {mul_en_out_reg[1:0], mul_en_in};
    end
end

assign mul_en_out = mul_en_out_reg[2];


wire [15:0] partial_products [7:0];
generate
    genvar i;
    for (i=0;
 i<8;
 i=i+1) begin : pp_gen
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
    end
endgenerate


reg [15:0] sum0_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0_reg <= 16'b0;
    end else begin
        sum0_reg <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
    end
end


reg [15:0] sum1_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1_reg <= 16'b0;
    end else begin
        sum1_reg <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
    end
end


reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum0_reg + sum1_reg;
    end
end

assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
