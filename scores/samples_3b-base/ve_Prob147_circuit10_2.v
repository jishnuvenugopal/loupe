
module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    
    reg flip_flop;

    
    always @(posedge clk) begin
        flip_flop <= a ^ b;
    end

    
    assign q = flip_flop;

    
    assign state = flip_flop;

endmodule
