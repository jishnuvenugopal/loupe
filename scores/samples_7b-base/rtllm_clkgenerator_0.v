
module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

    initial begin
        clk = 0;
        forever #10 begin
            clk = ~clk;
        end
    end

endmodule
