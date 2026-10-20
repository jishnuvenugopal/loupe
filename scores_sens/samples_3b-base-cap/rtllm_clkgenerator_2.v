
module clkgenerator (
    output reg clk
);

    
    parameter PERIOD = 10;

    
    initial begin
        clk = 0;
 
        #PERIOD/2;
 
        clk = 1;
 
        #PERIOD/2;
 
    end

endmodule
