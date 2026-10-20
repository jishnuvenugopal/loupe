
module TopModule (
    input  clk,
    input  in,
    output out
);

    
    reg D;
    reg Q;

    
    assign D = in ^ Q;

    
    always @(posedge clk) begin
        Q <= D;
    end

    
    assign out = Q;

endmodule
