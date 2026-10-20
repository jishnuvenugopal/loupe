
module clkgenerator #(parameter PERIOD = 10) (output clk);
    reg clk_reg;
    assign clk = clk_reg;
    
    initial begin
        clk_reg = 0;
    end
    
    always begin
        # (PERIOD / 2) clk_reg = ~clk_reg;
    end
endmodule
