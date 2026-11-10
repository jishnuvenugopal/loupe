
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg d;
    reg q;

    
    always @(posedge clk) begin
        q <= d;
    end

    
    assign out = in ^ q;

endmodule
