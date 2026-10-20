
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
        
        Q <= {Q[0], w};
    end else if (R) begin
        
        Q <= (L) ? w : 1'b0;
    end
    
end




endmodule
