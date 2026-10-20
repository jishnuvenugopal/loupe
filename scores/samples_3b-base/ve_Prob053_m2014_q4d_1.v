
module TopModule (
    input  clk,
    input  in,
    output out
);

    
    reg out_reg;

    
    assign out = in ^ out_reg;

    
    always @(posedge clk) begin
        out_reg <= out;
    end

endmodule
