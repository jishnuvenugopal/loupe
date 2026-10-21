
module TopModule (
    input wire d,
    input wire ena,
    output reg q
);

    
    reg reset;

    
    always @(posedge ena or posedge reset) begin
        if (reset) begin
            q <= 1'b0;
 
        end else begin
            q <= d;
 
        end
    end

endmodule
