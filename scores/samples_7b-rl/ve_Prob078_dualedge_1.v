
module TopModule (
    input clk,
    input d,
    output q
);
    
    reg q_ff1, q_ff2;
    
    
    always @(posedge clk) begin
        q_ff1 <= d;
    end
    
    
    always @(negedge clk) begin
        q_ff2 <= d;
    end
    
    
    assign q = clk ? q_ff1 : q_ff2;
    
endmodule
