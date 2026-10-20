
module clkgenerator #(parameter PERIOD = 10) (output reg clk);

initial begin
    clk = 0;
end

always begin
    # (PERIOD / 2.0) clk = ~clk;
end

endmodule
