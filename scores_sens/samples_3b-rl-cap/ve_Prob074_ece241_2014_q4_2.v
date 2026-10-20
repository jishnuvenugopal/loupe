
module TopModule (
    input clk,
    input x,
    output z
);

    
    reg dff0, dff1, dff2;

    
    wire x_xor, x_and, x_or, x_and_not, x_or_not;

    
    assign x_xor = x ^ dff0;

    
    assign x_and = x & ~dff0;

    
    assign x_or = x | ~dff0;

    
    assign x_and_not = ~dff1;

    
    assign x_or_not = ~dff2;

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            dff0 <= x_xor;
        end
    end

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            dff1 <= x_and;
        end
    end

    
    always @(posedge clk) begin
        if (clk == 1'b1) begin
            dff2 <= x_or;
        end
    end

    
    assign z = ~(dff0 & dff1 & dff2);

endmodule
