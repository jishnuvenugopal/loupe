
module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R,
    input  wire E,
    input  wire L,
    output reg  Q
);

always @(posedge clk) begin
    if (E) begin
        
        Q <= {Q[30:0], 1'b0};
    end else if (R && !L) begin
        
        Q <= w;
    end else if (L && !R) begin
        
        Q <= 1'b0;
    end
    
end



endmodule
