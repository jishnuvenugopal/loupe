
module TopModule (
    input clk,
    input a,
    output q
);

    
    always_ff @(posedge clk) begin
        if (a == 1'b1) begin
            q <= ~q;
 
        end else begin
            q <= q;
 
        end
    end

endmodule
