
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg [1:0] d_flip_flop;

    
    always @(posedge clk) begin
        d_flip_flop <= in ^ d_flip_flop;
    end

    
    assign out = d_flip_flop;

endmodule
