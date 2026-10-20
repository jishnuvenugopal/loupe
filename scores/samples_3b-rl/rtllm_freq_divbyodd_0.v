
module freq_divbyodd (
    input        clk,
    input        rst_n,
    output       clk_div
);

    
    parameter NUM_DIV = 5;

    
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt1;
    reg [COUNTER_WIDTH-1:0] cnt2;

    
    reg clk_div1;
    reg clk_div2;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt1 <= 0;
        else
            cnt1 <= (cnt1 == NUM_DIV-1) ? 0 : cnt1 + 1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt2 <= 0;
        else
            cnt2 <= (cnt2 == NUM_DIV-1) ? 0 : cnt2 + 1;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div1 <= 1'b0;
        else
            clk_div1 <= (cnt1 < (NUM_DIV/2)) ? 1'b1 : 1'b0;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div2 <= 1'b0;
        else
            clk_div2 <= (cnt2 < (NUM_DIV/2)) ? 1'b1 : 1'b0;
    end

    
    assign clk_div = clk_div1 | clk_div2;

endmodule
