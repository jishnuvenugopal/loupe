
module TopModule (
    input  clk,
    input  d,
    output q
);

    
    reg ce;

    
    always @(posedge clk or negedge clk) begin
        if (clk) begin
            
            ce <= 1;
        end else begin
            
            ce <= 0;
        end
    end

    
    always @(posedge clk or negedge clk) begin
        if (ce) begin
            
            q <= d;
        end
    end

endmodule
