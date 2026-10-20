
module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    wire [2*size-1:0] partial_products[size-1:0];
    reg [2*size-1:0] sum_reg;
    reg [2*size-1:0] mul_out_reg;

    
    wire [2*size-1:0] extended_mul_a = {size{1'b0}, mul_a};
    wire [2*size-1:0] extended_mul_b = {size{1'b0}, mul_b};

    
    generate
        genvar i;
        for (i = 0;
 i < size;
 i = i + 1) begin : gen_partial_products
            assign partial_products[i] = (mul_b[i] == 1'b1) ? (extended_mul_a << i) : 2*size{1'b0};
        end
    endgenerate

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 2*size{1'b0};
        end else begin
            sum_reg <= sum_reg + partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 2*size{1'b0};
        end else begin
            mul_out_reg <= sum_reg;
        end
    end

    assign mul_out = mul_out_reg;

endmodule
