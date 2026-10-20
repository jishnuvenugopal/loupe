
module clkgenerator (
    input wire clk_in, 
    output reg clk 
);

    parameter PERIOD = 10;
 

    always @(posedge clk_in) begin
        clk <= ~clk;
 
    end

endmodule
