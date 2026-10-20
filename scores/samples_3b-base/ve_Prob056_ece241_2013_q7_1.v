
module TopModule (
    input  clk,
    input  j,
    input  k,
    output Q
);

    
    reg Qold;

    
    always @(posedge clk) begin
        
        if (j) begin
            Q = 1'b1;
        
        end else if (k) begin
            Q = 1'b0;
        
        end else begin
            Q = ~Qold;
        end
        
        Qold = Q;
    end

endmodule
