
module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    
    reg [1:0] flip_flop;

    
    always @(posedge clk) begin
        
        flip_flop <= {flip_flop[0], a, b};
        
        q <= flip_flop[0];
        
        state <= flip_flop[1];
    end

endmodule
