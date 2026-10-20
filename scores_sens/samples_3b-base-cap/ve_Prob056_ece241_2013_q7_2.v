
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
        
        else if (j) begin
            Q <= 1'b1;
        
        else if (k) begin
            Q <= 1'b0;
        
        else begin
            Q <= Qold;
        end
    end

endmodule
