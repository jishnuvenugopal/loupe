
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg d_flip_flop_out;

    
    always @(posedge clk) begin
        d_flip_flop_out <= in;
    end

    
    assign out = d_flip_flop_out ^ in;

endmodule
