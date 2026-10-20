
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
    reg [3:0] enable_pipe;
    reg [15:0] mul_out_reg;

    wire [15:0] partial_products [0:7];
    genvar i;

    
    generate
        for (i = 0;
 i < 8;
 i = i + 1) begin : PARTIAL
            assign partial_products[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
        end
    endgenerate

    
    wire [15:0] sum;
    assign sum = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3]
               + partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 4'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            enable_pipe <= { enable_pipe[2:0], mul_en_in };
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else if (enable_pipe[3]) begin
            mul_out_reg <= sum;
        end
    end

    
    assign mul_en_out = enable_pipe[3];
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
