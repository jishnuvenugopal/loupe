
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

    reg [3:0] en_pipe;
    reg [7:0] a_reg, b_reg;
    wire [15:0] partial_products [0:7];
    wire [15:0] sum_total;
    reg [15:0] product_reg;

    
    genvar i;
    generate
        for (i = 0;
 i < 8;
 i = i + 1) begin : gen_partial
            assign partial_products[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    
    assign sum_total = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3]
                     + partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];

    
    assign mul_en_out = en_pipe[3];
    assign mul_out = mul_en_out ? product_reg : 16'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe <= 4'b0;
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            product_reg <= 16'b0;
        end else begin
            en_pipe <= {en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end
            product_reg <= sum_total;
        end
    end

endmodule
