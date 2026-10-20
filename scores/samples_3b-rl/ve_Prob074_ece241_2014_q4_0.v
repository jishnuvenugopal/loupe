
module TopModule (
    input  wire clk,
    input  wire x,
    output wire z
);

    
    wire DFF1, DFF2, DFF3;

    
    wire XOR_out;
    assign XOR_out = x ^ DFF1;

    
    wire AND_out;
    assign AND_out = x & ~DFF1;

    
    wire OR_out;
    assign OR_out = x | ~DFF1;

    
    always @(posedge clk) begin
        if (clk == 1'b1)
            DFF1 <= XOR_out;
    end

    
    always @(posedge clk) begin
        if (clk == 1'b1)
            DFF2 <= AND_out;
    end

    
    always @(posedge clk) begin
        if (clk == 1'b1)
            DFF3 <= OR_out;
    end

    
    assign z = ~(DFF1 ^ DFF2 ^ DFF3);

endmodule
