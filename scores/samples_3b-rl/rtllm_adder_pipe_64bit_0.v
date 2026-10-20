
module adder_pipe_64bit (
    input        clk,
    input        rst_n,
    input        i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output reg [64:0] result,
    output reg       o_en
);

    
    reg [63:0] sum_reg [5:0];
    reg        i_en_reg;
    reg        o_en_reg;
    reg        carry_in;

    
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_en_reg     <= 1'b0;
            o_en_reg     <= 1'b0;
            carry_in     <= 1'b0;
            sum_reg      <= {64{1'b0}};
            result       <= {65{1'b0}};
            o_en         <= 1'b0;
        end else begin
            i_en_reg <= i_en;

            
            sum_reg[0] <= adda + addb + carry_in;

            
            for (i = 1;
 i < 6;
 i = i + 1) begin
                sum_reg[i] <= sum_reg[i-1] + carry_in;
            end

            
            sum_reg[6] <= sum_reg[5] + carry_in;

            
            o_en_reg <= i_en_reg;

            
            result <= {1'b0, sum_reg[6]};

            
            o_en <= o_en_reg;
        end
    end

endmodule
