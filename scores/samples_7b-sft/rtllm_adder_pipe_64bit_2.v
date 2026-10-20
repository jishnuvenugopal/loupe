
module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output o_en
);


reg [1:0] en_pipe;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_pipe <= 2'b00;
    end else begin
        en_pipe <= {en_pipe[0], i_en};
    end
end

assign o_en = en_pipe[1];


reg [63:0] stage1_adda, stage1_addb;
reg stage1_valid;


reg [31:0] stage2_sum_low;
reg stage2_carry;
reg [31:0] stage2_adda_high, stage2_addb_high;
reg stage2_valid;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_adda <= 64'b0;
        stage1_addb <= 64'b0;
        stage1_valid <= 1'b0;
    end else begin
        if (i_en) begin
            stage1_adda <= adda;
            stage1_addb <= addb;
            stage1_valid <= 1'b1;
        end else begin
            stage1_valid <= 1'b0;
        end
    end
end


wire [32:0] sum_low_full = stage1_adda[31:0] + stage1_addb[31:0];


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum_low <= 32'b0;
        stage2_carry <= 1'b0;
        stage2_adda_high <= 32'b0;
        stage2_addb_high <= 32'b0;
        stage2_valid <= 1'b0;
    end else begin
        if (stage1_valid) begin
            stage2_sum_low <= sum_low_full[31:0];
            stage2_carry <= sum_low_full[32];
            stage2_adda_high <= stage1_adda[63:32];
            stage2_addb_high <= stage1_addb[63:32];
            stage2_valid <= 1'b1;
        end else begin
            stage2_valid <= 1'b0;
        end
    end
end


wire [32:0] sum_high_full = stage2_adda_high + stage2_addb_high + stage2_carry;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
    end else begin
        if (stage2_valid) begin
            result <= {sum_high_full[32], sum_high_full[31:0], stage2_sum_low};
        end else begin
            result <= 65'b0;
        end
    end
end

endmodule
