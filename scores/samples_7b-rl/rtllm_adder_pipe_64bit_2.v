
module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

    
    reg [63:0] a_reg1, b_reg1;
    reg en_reg1;

    
    reg [31:0] sum_lower_reg;
    reg [63:0] a_reg2, b_reg2;
    reg en_reg2;

    
    wire [32:0] sum_lower;
    assign sum_lower = {1'b0, a_reg1[31:0]} + {1'b0, b_reg1[31:0]};
    wire carry_lower = sum_lower[32];
    wire [31:0] sum_lower_val = sum_lower[31:0];

    
    wire [32:0] sum_upper;
    assign sum_upper = {1'b0, a_reg2[63:32]} + {1'b0, b_reg2[63:32]} + carry_lower;

    
    assign result = {sum_upper[32], sum_upper[31:0], sum_lower_reg};
    assign o_en = en_reg2;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg1 <= 64'b0;
            b_reg1 <= 64'b0;
            en_reg1 <= 0;
            a_reg2 <= 64'b0;
            b_reg2 <= 64'b0;
            sum_lower_reg <= 32'b0;
            en_reg2 <= 0;
        end else begin
            
            if (i_en && !en_reg1) begin
                a_reg1 <= adda;
                b_reg1 <= addb;
                en_reg1 <= 1;
            end

            
            if (en_reg1) begin
                a_reg2 <= a_reg1;
                b_reg2 <= b_reg1;
                sum_lower_reg <= sum_lower_val;
                en_reg1 <= 0;
                en_reg2 <= 1;
            end

            
            if (en_reg2) begin
                en_reg2 <= 0;
            end
        end
    end

endmodule
