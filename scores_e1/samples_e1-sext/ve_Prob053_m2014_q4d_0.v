
module TopModule (
    input clk,
    input in,
    output out
);

    
    reg out_reg;

    
    always @(posedge clk) begin
        out_reg <= in;
    end

    
    assign out = in ^ out_reg;

endmodule
