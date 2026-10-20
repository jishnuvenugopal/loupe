
module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output reg  out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    
    assign out_assign = a ^ b;

    
    always @(*) begin
        out_always_comb = a ^ b;
    end

    
    reg xor_result;
    always @(posedge clk) begin
        xor_result <= a ^ b;
    end
    assign out_always_ff = xor_result;

endmodule
