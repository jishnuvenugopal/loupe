
module TopModule (
    input clk,
    input d,
    output reg q
);

    
    reg rising_edge;
    reg falling_edge;

    always @(posedge clk or negedge clk) begin
        if (clk == 1'b0) begin
            
            if (rising_edge) begin
                q <= d;
            end
        end else begin
            
            if (falling_edge) begin
                q <= q;
            end
        end
        
        rising_edge <= clk & ~q;
        falling_edge <= ~clk & q;
    end

endmodule
