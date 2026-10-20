
module multi_pipe_8bit (
    input        clk,
    input        rst_n,
    input        mul_en_in,
    input  [7:0] mul_a,
    input  [7:0] mul_b,
    output       mul_en_out,
    output [15:0] mul_out
);

    
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg [15:0] sum [0:7];
    reg [15:0] mul_out_reg;
    reg [15:0] temp [0:7];
    reg [15:0] mul_en_out_reg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out_reg <= 16'b0;
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
        for (integer i = 0;
 i < 8;
 i = i + 1) begin
            temp[i] = (mul_a_reg << i) & mul_b_reg;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum[0] <= 16'b0;
            for (integer i = 1;
 i < 8;
 i = i + 1) begin
                sum[i] <= 16'b0;
            end
        end else begin
            sum[0] <= temp[0];
            for (integer i = 1;
 i < 8;
 i = i + 1) begin
                sum[i] <= sum[i-1] + temp[i];
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else
            mul_out_reg <= sum[7];
    end

    
    assign mul_en_out = mul_en_out_reg[15];

    
    assign mul_out = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule
