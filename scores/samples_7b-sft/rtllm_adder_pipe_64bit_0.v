
module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);


reg [31:0] sum_low, sum_high;
reg carry_low, carry_high;


reg [1:0] en_pipe;


reg [63:0] adda_reg, addb_reg;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_low <= 32'b0;
        carry_low <= 1'b0;
        en_pipe[0] <= 1'b0;
    end else begin
        if (i_en) begin
            {carry_low, sum_low} <= adda_reg[31:0] + addb_reg[31:0];
        end
        en_pipe[0] <= i_en;
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_high <= 32'b0;
        carry_high <= 1'b0;
        en_pipe[1] <= 1'b0;
    end else begin
        if (en_pipe[0]) begin
            {carry_high, sum_high} <= adda_reg[63:32] + addb_reg[63:32] + carry_low;
        end
        en_pipe[1] <= en_pipe[0];
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (en_pipe[1]) begin
            result <= {carry_high, sum_high, sum_low};
        end
        o_en <= en_pipe[1];
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'b0;
        addb_reg <= 64'b0;
    end else begin
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
    end
end

endmodule
