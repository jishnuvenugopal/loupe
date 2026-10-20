
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
    reg en_reg;

    
    reg [64:0] sum_reg;

    
    wire [64:0] sum = {1'b0, a_reg} + {1'b0, b_reg};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 64'd0;
            b_reg <= 64'd0;
            en_reg <= 1'b0;
            sum_reg <= 65'd0;
            o_en <= 1'b0;
        end else begin
            
            if (i_en) begin
                a_reg <= adda;
                b_reg <= addb;
            end
            en_reg <= i_en;

            
            sum_reg <= sum;
            o_en <= en_reg;
        end
    end

    assign result = sum_reg;

endmodule
