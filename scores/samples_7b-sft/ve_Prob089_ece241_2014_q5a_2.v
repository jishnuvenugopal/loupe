
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        carry <= 0;
        z <= 0;
    end else begin
        
        reg sum = (~x) + carry;
        
        carry <= (sum >= 2) ? 1 : 0;
        
        z <= sum[0];
    end
end

endmodule
