
module multi_pipe_4bit (
    input        clk,
    input        rst_n,
    input [3:0]  mul_a,
    input [3:0]  mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;


wire [7:0] mul_a_ext, mul_b_ext;
assign mul_a_ext = {size{1'b0}}, mul_a;
assign mul_b_ext = {size{1'b0}}, mul_b;


reg [7:0] partial_sum1, partial_sum2;


generate
    genvar i;
    for (i = 0;
 i < size;
 i = i + 1) begin : gen_mult
        wire [7:0] partial_product;
        assign partial_product = (mul_b_ext[i] ? mul_a_ext << i : 8'b0);
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                partial_sum1 <= 8'b0;
            else
                partial_sum1 <= partial_sum1 + partial_product;
        end
        assign partial_sum2 = (mul_b_ext[i] ? mul_a_ext << i : 8'b0);
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                partial_sum2 <= 8'b0;
            else
                partial_sum2 <= partial_sum2 + partial_product;
        end
    end
endgenerate


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out <= 8'b0;
    else
        mul_out <= partial_sum1 + partial_sum2;
end

endmodule
