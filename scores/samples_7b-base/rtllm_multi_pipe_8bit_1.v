
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    reg mul_en_out_reg;
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg [7:0] temp [0:7];
    reg [15:0] sum [0:1];
    reg [15:0] mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 0;
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_en_out <= 0;
            mul_out <= 0;
        end else begin
            if (mul_en_in) begin
                mul_en_out_reg <= mul_en_in;
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            mul_en_out <= mul_en_out_reg;
        end
    end

    generate
        generate
            for (genvar i = 0;
 i < 8;
 i = i + 1) begin : gen_temp
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        temp[i] <= 0;
                    end else begin
                        if (mul_en_out_reg) begin
                            temp[i] <= mul_a_reg & (mul_b_reg >> i);
                        end
                    end
                end
            end
        endgenerate
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum[0] <= 0;
            sum[1] <= 0;
        end else begin
            if (mul_en_out_reg) begin
                sum[0] <= temp[0];
                sum[1] <= temp[0] + temp[1];
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
        end else begin
            if (mul_en_out_reg) begin
                mul_out_reg <= sum[1];
            end
        end
    end

    assign mul_out = mul_en_out ? mul_out_reg : 0;

endmodule
