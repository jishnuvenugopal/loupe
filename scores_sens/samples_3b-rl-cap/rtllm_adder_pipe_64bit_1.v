
module adder_pipe_64bit (
    input        clk,
    input        rst_n,
    input        i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    
    reg [63:0] adda_reg [63:0];
    reg [63:0] addb_reg [63:0];

    
    reg [64:0] sum_reg [63:0];
    reg        carry_reg [63:0];

    
    reg        en_reg [63:0];

    
    reg        en;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_reg[0] <= 1'b0;
        else if (i_en)
            en_reg[0] <= 1'b1;
        else
            en_reg[0] <= en_reg[0];
    end

    
    genvar i;
    generate
        for (i = 0;
 i < 64;
 i = i + 1) begin : pipeline_gen
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    adda_reg[i] <= {64'b0, 1'b0};
                else if (i_en)
                    adda_reg[i] <= adda;
                else
                    adda_reg[i] <= adda_reg[i];
            end
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    addb_reg[i] <= {64'b0, 1'b0};
                else if (i_en)
                    addb_reg[i] <= addb;
                else
                    addb_reg[i] <= addb_reg[i];
            end
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    sum_reg[i] <= {65'b0, 1'b0};
                else if (i_en && en_reg[i])
                    sum_reg[i] <= adda_reg[i] + addb_reg[i] + carry_reg[i];
                else
                    sum_reg[i] <= sum_reg[i];
            end
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    carry_reg[i] <= 1'b0;
                else if (i_en && en_reg[i])
                    carry_reg[i] <= (adda_reg[i] + addb_reg[i] + carry_reg[i])[64];
                else
                    carry_reg[i] <= carry_reg[i];
            end
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    en_reg[i] <= 1'b0;
                else if (i_en && en_reg[i])
                    en_reg[i] <= 1'b1;
                else
                    en_reg[i] <= en_reg[i];
            end
        end
    endgenerate

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en <= 1'b0;
        else if (i_en)
            en <= 1'b1;
        else
            en <= en_reg[63];
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            result <= {65'b0, 1'b0};
        else
            result <= sum_reg[63];
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            o_en <= 1'b0;
        else
            o_en <= en;
    end

endmodule
