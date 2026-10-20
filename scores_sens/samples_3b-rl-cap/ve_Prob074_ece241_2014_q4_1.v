
module TopModule (
    input clk,
    input x,
    output z
);

    
    wire xor_out;
    wire and_out;
    wire or_out;

    
    reg ff_xor;
    reg ff_and;
    reg ff_or;

    
    assign xor_out = x ^ ff_xor;

    
    assign and_out = x & ~ff_and;

    
    assign or_out = x | ~ff_or;

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            ff_xor <= xor_out;
        end
    end

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            ff_and <= and_out;
        end
    end

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            ff_or <= or_out;
        end
    end

    
    assign z = ~(ff_xor ^ ff_and ^ ff_or);

endmodule
