
module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    
    wire [2*size-1:0] mul_a_ext = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] mul_b_ext = {{size{1'b0}}, mul_b};

    
    wire [2*size-1:0] pp [0:size-1];

    generate
        genvar i;
        for (i=0;
 i<size;
 i=i+1) begin: gen_partial_products
            assign pp[i] = mul_b[i] ? (mul_a_ext << i) : 0;
        end
    endgenerate

    
    wire [2*size-1:0] sum_total = pp[0] + pp[1] + pp[2] + pp[3];

    
    reg [2*size-1:0] sum_reg;
    reg [2*size-1:0] product_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 0;
            product_reg <= 0;
        end else begin
            sum_reg <= sum_total;
            product_reg <= sum_reg;
        end
    end

    assign mul_out = product_reg;

endmodule
