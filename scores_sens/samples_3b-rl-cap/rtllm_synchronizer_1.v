
module synchronizer (
    input        clk_a,
    input        clk_b,
    input        arstn,
    input        brstn,
    input  [3:0] data_in,
    input        data_en,
    output reg [3:0] dataout
);

    
    reg [3:0] data_reg;
    reg       data_en_reg;
    reg [1:0] en_clap_one;
    reg [1:0] en_clap_two;

    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'b0;
        else
            data_reg <= data_in;
    end

    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_en_reg <= 1'b0;
        else
            data_en_reg <= data_en;
    end

    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            en_clap_one <= 2'b0;
        else
            en_clap_one <= data_en_reg;
    end

    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            en_clap_two <= 2'b0;
        else
            en_clap_two <= en_clap_one;
    end

    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else if (en_clap_two == 2'b11)
            dataout <= data_reg;
    end

endmodule
