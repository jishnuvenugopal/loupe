
module adder_pipe_64bit (
    input        clk,
    input        rst_n,
    input        i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output reg [64:0] result,
    output reg       o_en
);

    
    reg [63:0] stage1_sum, stage2_sum, stage3_sum, stage4_sum;
    reg [63:0] stage1_carry, stage2_carry, stage3_carry, stage4_carry;

    
    reg i_en_reg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum      <= 64'd0;
            stage1_carry    <= 64'd0;
            stage2_sum      <= 64'd0;
            stage2_carry    <= 64'd0;
            stage3_sum      <= 64'd0;
            stage3_carry    <= 64'd0;
            stage4_sum      <= 64'd0;
            stage4_carry    <= 64'd0;
            i_en_reg        <= 1'b0;
            result          <= 65'd0;
            o_en            <= 1'b0;
        end else begin
            
            stage1_sum      <= adda + addb;
            stage1_carry    <= 64'd0;

            
            stage2_sum      <= stage1_sum + stage1_carry;
            stage2_carry    <= stage1_carry;

            
            stage3_sum      <= stage2_sum + stage2_carry;
            stage3_carry    <= stage2_carry;

            
            stage4_sum      <= stage3_sum + stage3_carry;
            stage4_carry    <= stage3_carry;

            
            i_en_reg        <= i_en;

            
            result          <= {stage4_carry, stage4_sum};
            o_en            <= i_en_reg;
        end
    end

endmodule
