
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [2:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;


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


wire [15:0] pp [7:0];
genvar i;
generate
    for (i = 0;
 i < 8;
 i = i + 1) begin : pp_gen
        assign pp[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
    end
endgenerate


wire [15:0] sum_comb;
assign sum_comb = pp[0] + pp[1] + pp[2] + pp[3] + pp[4] + pp[5] + pp[6] + pp[7];

reg [15:0] sum_reg;
reg [15:0] mul_out_reg;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 16'b0;
        mul_out_reg <= 16'b0;
    end else begin
        sum_reg <= sum_comb;
        mul_out_reg <= sum_reg;
    end
end

assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
