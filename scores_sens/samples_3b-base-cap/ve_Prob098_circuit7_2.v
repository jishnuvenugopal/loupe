
module TopModule (
    input  clk,
    input  a,
    output q
);

    
    reg q;

    
    always @(posedge clk) begin
        q <= a;
    end

endmodule
