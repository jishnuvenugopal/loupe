
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg [1:0] d_flip_flop;

    
    reg xor_result;

    
    always @(posedge clk) begin
        if (clk) begin
            d_flip_flop <= in;
        end
    end

    
    always @(d_flip_flop or in) begin
        xor_result <= d_flip_flop ^ in;
    end

    
    assign out = xor_result;

endmodule
