
module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg [15:0] mul_out,
    output reg mul_en_out
);

    
    reg [0:0] mul_en_out_reg;

    
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    
    wire [15:0] temp;

    
    reg [15:0] sum[0:7];

    
    reg [15:0] mul_out_reg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 0;
        end else begin
            mul_en_out_reg <= mul_en_in;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 0;
        end else begin
            temp <= {mul_a_reg, 8'b00000000};
            for (int i = 0;
 i < 8;
 i++) begin
                if (mul_b_reg[i]) begin
                    temp <= temp + mul_a_reg;
                end
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0;
 i < 8;
 i++) begin
                sum[i] <= 0;
            end
        end else begin
            for (int i = 0;
 i < 8;
 i++) begin
                sum[i] <= sum[i] + temp[15 - i:8 - i];
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
        end else begin
            mul_out_reg <= sum[7] + sum[6] + sum[5] + sum[4] + sum[3] + sum[2] + sum[1] + sum[0];
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= mul_out_reg;
        end
    end

endmodule
