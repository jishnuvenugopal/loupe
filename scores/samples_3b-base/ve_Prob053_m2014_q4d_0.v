
module TopModule (
    input  clk,
    input  in,
    output out
);

    
    reg d;
    reg q;

    
    wire xor_out;

    
    always @(posedge clk) begin
        d <= xor_out;
        q <= d;
    end

    
    always @(*) begin
        xor_out = in ^ q;
    end

    
    assign out = q;

endmodule
