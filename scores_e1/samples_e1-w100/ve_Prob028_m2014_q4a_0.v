
module TopModule (
    input wire d,
    input wire ena,
    output reg q
);

    
    reg reset = 1'b0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0;
 
        end else if (ena) begin
            q <= d;
 
        end
    end

endmodule
