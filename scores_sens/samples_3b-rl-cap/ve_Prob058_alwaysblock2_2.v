
module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output reg  out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    
    assign out_assign = a ^ b;

    
    reg xor_comb;
    always @(*) begin
        xor_comb = a ^ b;
    end
    assign out_always_comb = xor_comb;

    
    reg xor_ff;
    always @(posedge clk) begin
        xor_ff = a ^ b;
    end
    assign out_always_ff = xor_ff;

endmodule
