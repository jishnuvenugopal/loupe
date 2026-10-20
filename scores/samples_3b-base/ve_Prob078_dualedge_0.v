
module TopModule (
    input  clk,
    input  d,
    output q
);

    
    reg ce;

    
    always @(posedge clk or negedge clk) begin
        if (ce) begin
            q <= d;
        end
    end

endmodule
