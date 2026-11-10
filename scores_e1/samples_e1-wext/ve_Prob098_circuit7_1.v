
module TopModule (
    input clk,
    input a,
    output q
);

    
    reg q_reg;

    
    assign q_reg = 1'b0;

    
    always @(posedge clk) begin
        if (a != q_reg) begin
            q_reg <= ~q_reg;
        end
    end

    
    assign q = q_reg;

endmodule
