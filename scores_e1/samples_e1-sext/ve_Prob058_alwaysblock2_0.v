
module TopModule (
    input clk,
    input a,
    input b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    
    assign out_assign = a ^ b;

    
    always @(*) begin
        reg temp;
        temp = a ^ b;
        out_always_comb = temp;
    end

    
    always @(posedge clk) begin
        reg temp;
        temp = a ^ b;
        out_always_ff = temp;
    end

endmodule
