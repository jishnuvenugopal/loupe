
module multi_pipe_4bit (
    input wire clk,
    input wire rst_n,
    input wire [3:0] mul_a,
    input wire [3:0] mul_b,
    output reg [7:0] mul_out
);

    
    parameter size = 4;

    
    reg [7:0] extended_mul_a = {size{mul_a[3]}, mul_a};
    reg [7:0] extended_mul_b = {size{mul_b[3]}, mul_b};

    
    reg [7:0] sum_0;
    reg [7:0] sum_1;
    reg [7:0] sum_2;
    reg [7:0] sum_3;

    
    generate
        for (genvar i = 0;
 i < size;
 i++) begin
            
            reg [7:0] partial_product;
            if (extended_mul_b[size - 1 - i] == 1) begin
                partial_product = extended_mul_a << i;
            end else begin
                partial_product = 8'b0;
            end

            
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    sum_0 <= 8'b0;
                    sum_1 <= 8'b0;
                    sum_2 <= 8'b0;
                    sum_3 <= 8'b0;
                end else begin
                    case (i)
                        0: sum_0 <= sum_0 + partial_product;
                        1: sum_1 <= sum_1 + partial_product;
                        2: sum_2 <= sum_2 + partial_product;
                        3: sum_3 <= sum_3 + partial_product;
                    endcase
                end
            end
        end
    endgenerate

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'b0;
        end else begin
            mul_out <= sum_3 + (sum_2 << 4) + (sum_1 << 8) + (sum_0 << 12);
        end
    end

endmodule
