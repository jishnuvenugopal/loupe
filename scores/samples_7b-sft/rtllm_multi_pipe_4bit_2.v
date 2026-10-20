
module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);
    parameter size = 4;
    
    
    wire [7:0] mul_a_ext = {4'b0, mul_a};
    wire [7:0] mul_b_ext = {4'b0, mul_b};
    
    
    wire [7:0] pp [3:0];
    genvar i;
    generate
        for (i = 0;
 i < size;
 i = i + 1) begin : gen_partial
            assign pp[i] = mul_b_ext[i] ? (mul_a_ext << i) : 8'd0;
        end
    endgenerate
    
    
    reg [7:0] sum_reg;
    reg [7:0] product_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 8'd0;
            product_reg <= 8'd0;
            mul_out <= 8'd0;
        end else begin
            
            sum_reg <= pp[0] + pp[1] + pp[2] + pp[3];
            
            product_reg <= sum_reg;
            mul_out <= product_reg;
        end
    end
endmodule
