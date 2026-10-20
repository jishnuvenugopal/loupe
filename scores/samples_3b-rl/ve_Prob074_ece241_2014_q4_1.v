
module TopModule (
    input  wire clk,
    input  wire x,
    output wire z
);

    
    reg ff_xor;
    reg ff_and;
    reg ff_or;

    
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

    
    always @(posedge clk) begin
        
        ff_xor <= x ^ ff_xor;
        
        ff_and <= x & ~ff_and;
        
        ff_or  <= x | ~ff_or;
    end

    
    assign z = ~(ff_xor ^ ff_and ^ ff_or);

endmodule
