
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

    
    always @(posedge clk) begin
        xor_result <= in ^ d_flip_flop;
    end

    
    assign out = xor_result;

endmodule
