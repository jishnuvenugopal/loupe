
module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= 1'b1;
 
    end else begin
        if (out == 1'b1) begin
            
            
            out <= in;
        end else begin
            
            
            out <= ~in;
        end
    end
end




endmodule
