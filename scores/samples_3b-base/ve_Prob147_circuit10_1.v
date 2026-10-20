
module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    
    reg q_reg;

    
    always @(posedge clk) begin
        
        q_reg <= a & b;
    end

    
    always @(posedge clk) begin
        
        state <= q_reg;
    end

endmodule
