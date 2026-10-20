
module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    
    reg q_reg;

    
    always @(posedge clk) begin
        
        q = q_reg;

        
        state = a & b;
    end

    
    always @(posedge clk) begin
        if (a) begin
            q_reg <= 1'b1;
        end else begin
            q_reg <= 1'b0;
        end
    end

endmodule
