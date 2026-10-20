
module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);


reg [63:0] adda_reg, addb_reg;
reg i_en_reg1;
reg [31:0] sum_low_reg;
reg carry_out_stage1_reg;
reg [31:0] adda_high_reg, addb_high_reg;
reg carry_out_stage2_reg;
reg [31:0] sum_high_reg;
reg i_en_reg2;


reg [1:0] o_en_shift;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'b0;
        addb_reg <= 64'b0;
        i_en_reg1 <= 1'b0;
        sum_low_reg <= 32'b0;
        carry_out_stage1_reg <= 1'b0;
        adda_high_reg <= 32'b0;
        addb_high_reg <= 32'b0;
        carry_out_stage2_reg <= 1'b0;
        sum_high_reg <= 32'b0;
        i_en_reg2 <= 1'b0;
        o_en_shift <= 2'b00;
    end else begin
        
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end

        
        {carry_out_stage1_reg, sum_low_reg} <= adda_reg[31:0] + addb_reg[31:0];
        adda_high_reg <= adda_reg[63:32];
        addb_high_reg <= addb_reg[63:32];
        i_en_reg1 <= i_en;

        
        {carry_out_stage2_reg, sum_high_reg} <= adda_high_reg + addb_high_reg + carry_out_stage1_reg;
        i_en_reg2 <= i_en_reg1;

        
        o_en_shift <= {o_en_shift[0], i_en};
    end
end


always @(*) begin
    result = {carry_out_stage2_reg, sum_high_reg, sum_low_reg};
    o_en = o_en_shift[1];
end

endmodule
