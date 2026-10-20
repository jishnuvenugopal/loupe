
module TopModule (
    input  clk,
    input  in,
    output out
);

    
    reg Q;

    
    always @(posedge clk) begin
        Q <= in ^ Q;
 
    end

    
    assign out = Q;

endmodule
