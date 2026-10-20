
module multi_pipe_4bit (
    input wire clk,
    input wire rst_n,
    input wire [3:0] mul_a,
    input wire [3:0] mul_b,
    output reg [7:0] mul_out
);

    
    reg [3:0] partial_products [0:3];
    reg [7:0] intermediate_sums [0:3];

    generate
        for (genvar i = 0;
 i < 4;
 i = i + 1) begin : multiplier_loop
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_products[i] <= 4'b0000;
                end else begin
                    if (mul_b[i]) begin
                        partial_products[i] <= mul_a << i;
                    end else begin
                        partial_products[i] <= 4'b0000;
                    end
                end
            end
        end
    endgenerate

    generate
        for (genvar i = 0;
 i < 4;
 i = i + 1) begin : adder_loop
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    intermediate_sums[i] <= 8'b00000000;
                end else begin
                    intermediate_sums[i] <= (i == 0) ? partial_products[i] : intermediate_sums[i-1] + partial_products[i];
                end
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'b00000000;
        end else begin
            mul_out <= intermediate_sums[3];
        end
    end

endmodule
