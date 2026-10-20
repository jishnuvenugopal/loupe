
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    reg carry;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            carry <= 1;
        else
            carry <= (~x) & carry;
    end
    
    assign z = (~x) ^ carry;
    
endmodule
