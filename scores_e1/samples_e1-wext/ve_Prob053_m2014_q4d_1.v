
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg d;
    reg q;

    always @(posedge clk) begin
        q <= d;
    end

    
    reg xor_out;

    always @(posedge clk or in) begin
        xor_out <= in ^ q;
    end

    
    assign out = xor_out;

endmodule
