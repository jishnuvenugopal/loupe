
module multi_pipe_8bit (
    input        clk,
    input        rst_n,
    input        mul_en_in,
    input  [7:0] mul_a,
    input  [7:0] mul_b,
    output       mul_en_out,
    output [15:0] mul_out
);

    
    reg [1:0] mul_en_out_reg;
    reg [15:0] mul_out_reg;
    reg [15:0] sum [3:0];
    wire [15:0] temp [7:0];

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out_reg <= 2'b00;
        else
            mul_en_out_reg <= {mul_en_in, mul_en_out_reg[1:0]};
    end

    
    assign mul_en_out = mul_en_out_reg[1];

    
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_a_reg <= 8'b0;
        else
            mul_a_reg <= mul_a;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_b_reg <= 8'b0;
        else
            mul_b_reg <= mul_b;
    end

    
    generate
        genvar i;
        generate
            for (i = 0;
 i < 8;
 i = i + 1) begin : partial_product_gen
                assign temp[i] = mul_a_reg << i & mul_b_reg;
            end
        endgenerate
    endgenerate

    
    reg [15:0] sum_reg [3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_reg <= 4'b0;
        else begin
            sum_reg[0] <= temp[0];
            sum_reg[1] <= sum_reg[0] + temp[1];
            sum_reg[2] <= sum_reg[1] + temp[2];
            sum_reg[3] <= sum_reg[2] + temp[3];
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else
            mul_out_reg <= sum_reg[3];
    end

    
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
