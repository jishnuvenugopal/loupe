
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg [1:0] d;
    reg q;
    reg q_prev;

    
    reg xor_out;

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            q_prev <= q;
            q <= d;
        end
    end

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            xor_out <= in ^ q;
        end
    end

    
    assign out = xor_out;

endmodule
