
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg d;
    reg q;

    
    assign d = in ^ q;

    
    always @(posedge clk) begin
        q <= d;
    end

endmodule
