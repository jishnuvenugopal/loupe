
module multi_pipe_4bit (
    input wire clk,
    input wire rst_n,
    input wire [3:0] mul_a,
    input wire [3:0] mul_b,
    output reg [7:0] mul_out
);

    parameter size = 4;
    reg [3:0] extended_mul_a;
    reg [3:0] partial_products [3:0];
    reg [7:0] sum_reg;
    reg [7:0] final_product;

    
    assign extended_mul_a = {mul_a, {size{1'b0}}};

    
    generate
        genvar i;
        for (i = 0;
 i < size;
 i = i + 1) begin: partial_product_generator
            assign partial_products[i] = (mul_b[i] == 1'b1) ? (extended_mul_a << i) : 4'b0;
        end
    endgenerate

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 8'b0;
        end else begin
            sum_reg <= sum_reg + partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'b0;
        end else begin
            mul_out <= sum_reg;
        end
    end

endmodule
