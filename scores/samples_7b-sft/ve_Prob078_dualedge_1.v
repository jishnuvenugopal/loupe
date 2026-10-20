
module TopModule (
    input clk,
    input d,
    output q
);
    reg ff1, ff2;
    
    always @(posedge clk) begin
        ff1 <= d;
    end
    
    always @(negedge clk) begin
        ff2 <= d;
    end
    
    assign q = clk ? ff2 : ff1;
    
endmodule
