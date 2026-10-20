
module multi_pipe_4bit (
    input        clk,
    input        rst_n,
    input [3:0]  mul_a,
    input [3:0]  mul_b,
    output reg [7:0] mul_out
);

    
    parameter size = 4;

    
    wire [7:0] mul_a_ext = {size{1'b0}}, mul_b_ext = {size{1'b0}};
    assign mul_a_ext = mul_a;
    assign mul_b_ext = mul_b;

    
    reg [7:0] partial_product0, partial_product1;

    
    reg [7:0] sum;

    
    reg [7:0] product;

    
    generate
        for (genvar i = 0;
 i < size;
 i = i + 1) begin : partial_product_gen
            
            assign partial_product0 = (mul_b_ext[i] ? mul_a_ext << i : 8'b0);
            assign partial_product1 = (mul_b_ext[i+1] ? mul_a_ext << (i+1) : 8'b0);
        end
    endgenerate

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 8'b0;
        end else begin
            sum <= partial_product0 + partial_product1;
        end
    end

    
    reg [7:0] sum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 8'b0;
        end else begin
            sum_reg <= sum;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 8'b0;
        end else begin
            product <= sum_reg;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'b0;
        end else begin
            mul_out <= product;
        end
    end

endmodule
