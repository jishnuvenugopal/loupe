
module multi_pipe_4bit (
    input wire clk,
    input wire rst_n,
    input wire [3:0] mul_a,
    input wire [3:0] mul_b,
    output reg [7:0] mul_out
);

    
    reg [7:0] ext_mul_a;
    reg [7:0] ext_mul_b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ext_mul_a <= 8'b0;
            ext_mul_b <= 8'b0;
        end else begin
            ext_mul_a <= {mul_a, 4'b0};
            ext_mul_b <= {mul_b, 4'b0};
        end
    end

    
    generate
        for (genvar i = 0;
 i < 4;
 i++) begin
            reg [7:0] partial_product;
            reg [7:0] sum;

            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_product <= 8'b0;
                    sum <= 8'b0;
                end else begin
                    if (ext_mul_b[i]) begin
                        partial_product <= ext_mul_a << i;
                    end else begin
                        partial_product <= 8'b0;
                    end

                    sum <= sum + partial_product;
                end
            end

            
            reg [7:0] reg_sum;

            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    reg_sum <= 8'b0;
                end else begin
                    reg_sum <= sum;
                end
            end
        end
    endgenerate

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'b0;
        end else begin
            mul_out <= reg_sum;
        end
    end

endmodule
