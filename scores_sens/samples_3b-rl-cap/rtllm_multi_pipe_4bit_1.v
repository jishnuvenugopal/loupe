
module multi_pipe_4bit (
    input        clk,
    input        rst_n,
    input  [3:0] mul_a,
    input  [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] reg_sum1;
reg [7:0] reg_sum2;


wire [3:0] mul_a_ext = {size{1'b0}}, mul_b_ext = {size{1'b0}};


generate
    genvar i;
    for (i = 0;
 i < size;
 i = i + 1) begin : gen_mul
        wire [7:0] partial_product;
        assign partial_product = (mul_b_ext[i] ? mul_a_ext << i : 8'b0);
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                reg_sum1 <= 8'b0;
            else if (i == 0)
                reg_sum1 <= partial_product;
            else
                reg_sum1 <= reg_sum1 + partial_product;
        end
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                reg_sum2 <= 8'b0;
            else if (i == 1)
                reg_sum2 <= partial_product;
            else
                reg_sum2 <= reg_sum2 + partial_product;
        end
    end
endgenerate


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out <= 8'b0;
    else
        mul_out <= reg_sum1 + reg_sum2;
end

endmodule
