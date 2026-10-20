
module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    reg [63:0] a_reg, b_reg;
    reg i_en_reg;
    
    wire [64:0] sum = {1'b0, a_reg} + {1'b0, b_reg};
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 0;
            b_reg <= 0;
            i_en_reg <= 0;
        end else begin
            if (i_en) begin
                a_reg <= adda;
                b_reg <= addb;
            end
            i_en_reg <= i_en;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
            o_en <= 0;
        end else begin
            result <= sum;
            o_en <= i_en_reg;
        end
    end

endmodule
