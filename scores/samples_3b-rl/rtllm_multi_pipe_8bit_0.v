
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg [15:0] mul_out_reg;
    reg [15:0] sum [3:0];
    reg [15:0] mul_en_out_reg;

    
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

    
    wire [7:0] temp [7:0];
    integer i, j;
    always @(*) begin
        for (i = 0;
 i < 8;
 i = i + 1) begin
            for (j = 0;
 j < 8;
 j = j + 1) begin
                if (mul_b_reg[j])
                    temp[i] = temp[i] | (mul_a_reg & {8{mul_b_reg[j]}});
                else
                    temp[i] = temp[i] | 8'b0;
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum[0] <= 16'b0;
        else
            sum[0] <= temp[0];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum[1] <= 16'b0;
        else
            sum[1] <= sum[0] + temp[1];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum[2] <= 16'b0;
        else
            sum[2] <= sum[1] + temp[2];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum[3] <= 16'b0;
        else
            sum[3] <= sum[2] + temp[3];
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else
            mul_out_reg <= sum[3];
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out_reg <= 16'b0;
        else
            mul_en_out_reg <= {1'b0, mul_en_in};
    end

    assign mul_en_out = mul_en_out_reg[15];

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 16'b0;
        else if (mul_en_out)
            mul_out <= mul_out_reg;
        else
            mul_out <= 16'b0;
    end

endmodule
