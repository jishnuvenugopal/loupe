
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg d;
    reg q;

    
    reg xor_out;

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            q <= d;
        end
    end

    
    always @(posedge clk) begin
        xor_out <= in ^ q;
    end

    
    assign out = xor_out;

endmodule
