
module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output Q
);

    
    reg Q_reg;

    
    always @(posedge clk) begin
        
        if (E && !L) begin
            Q_reg <= w;
        
        else if (R) begin
            Q_reg <= w;
        
        else begin
            Q_reg <= Q_reg;
        end
    end

    
    assign Q = Q_reg;

endmodule
