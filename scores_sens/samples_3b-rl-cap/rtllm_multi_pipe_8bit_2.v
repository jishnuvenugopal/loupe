
module multi_pipe_8bit (
    input        clk,
    input        rst_n,
    input        mul_en_in,
    input  [7:0] mul_a,
    input  [7:0] mul_b,
    output       mul_en_out,
    output [15:0] mul_out
);

    
    reg [15:0] mul_out_reg;
    reg        mul_en_out_reg;
    reg [7:0]  mul_a_reg;
    reg [7:0]  mul_b_reg;
    reg [15:0] sum [3:0];
    reg [15:0] temp [7:0];

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out_reg <= 1'b0;
        else
            mul_en_out_reg <= mul_en_in;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    
    always @(*) begin
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            temp[i] = (mul_a_reg & (8'b1 << i)) ? mul_b_reg : 8'b0;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum[0] <= 16'b0;
            sum[1] <= 16'b0;
            sum[2] <= 16'b0;
            sum[3] <= 16'b0;
        end else begin
            sum[0] <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
            sum[1] <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
            sum[2] <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
            sum[3] <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else
            mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3];
    end

    
    assign mul_en_out = mul_en_out_reg;

    
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
