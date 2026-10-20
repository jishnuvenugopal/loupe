
module TopModule (
    input clk,
    input x,
    output z
);

    
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or = 1'b0;

    
    wire D_xor = x ^ q_xor;
        
    wire D_and = x & ~q_and;
      
    wire D_or = x | ~q_or;
        

    
    wire xnortemp = (q_xor ~^ q_and);
  
    assign z = xnortemp ~^ q_or;

    
    always @(posedge clk) begin
        q_xor <= D_xor;
        q_and <= D_and;
        q_or <= D_or;
    end

endmodule
