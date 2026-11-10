
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg d;
    reg q;

    
    reg xor_out;

    
    always @(posedge clk) begin
        q <= d;
    end

    
    assign xor_out = in ^ q;

    
    assign out = xor_out;

endmodule
