
module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

    
    reg Qold;

    
    always @(posedge clk) begin
        
        if (j && k) begin
            Q <= ~Qold;
        
        else if (!j && !k) begin
            Q <= Qold;
        
        else if (j && !k) begin
            Q <= 1;
        
        else if (!j && k) begin
            Q <= 0;
        end
    end

endmodule
