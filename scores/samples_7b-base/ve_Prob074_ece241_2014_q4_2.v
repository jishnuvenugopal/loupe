
module TopModule(clk, x, z);
    input clk;
    input x;
    output z;

    reg x_or_ff;
    reg x_and_ff;
    reg x_or_bar_ff;
    reg x_and_bar_ff;
    reg x_or_and_bar_xnor_out;

    
    always @(posedge clk) begin
        x_or_ff <= x ^ x_or_ff;
        x_and_ff <= x & ~x_or_ff;
        x_or_bar_ff <= ~x | ~x_or_ff;
        x_and_bar_ff <= ~x & ~x_or_ff;
    end

    
    assign x_or_and_bar_xnor_out = x_or_ff ^ x_and_bar_ff ^ x_and_bar_ff;

    
    assign z = x_or_and_bar_xnor_out;

endmodule
