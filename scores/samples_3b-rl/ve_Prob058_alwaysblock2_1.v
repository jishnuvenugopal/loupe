
module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    
    reg out_ff;

    
    assign out_assign = a ^ b;

    
    reg out_comb;
    always @(*) begin
        out_comb = a ^ b;
    end
    assign out_always_comb = out_comb;

    
    always @(posedge clk) begin
        out_ff <= a ^ b;
    end
    assign out_always_ff = out_ff;

endmodule
