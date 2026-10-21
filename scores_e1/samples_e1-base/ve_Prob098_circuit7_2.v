
module TopModule (
    input clk,
    input a,
    output q
);

    
    reg q = 0;

    
    always @(posedge clk) begin
        if (a == 1) begin
            q <= ~q;
        end
    end

endmodule
